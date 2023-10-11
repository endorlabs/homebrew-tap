require 'net/http'

class EndorDownloadStrategy < CurlDownloadStrategy
  def url
    versioned_url = $download_url
    versioned_url
  end
end

class Endorctl < Formula

  homepage "https://github.com/endorlabs/homebrew-tap"
  desc "Endor Labs Homebrew Tap"
  version "latest"

  # Get latest version metadata
  version_uri = URI("https://api.endorlabs.com/meta/version")
  http = Net::HTTP.new(version_uri.host, version_uri.port)
  http.use_ssl = true

  req = Net::HTTP::Get.new(version_uri)
  res = http.request(req)
  if res.is_a?(Net::HTTPSuccess)
    json_data = JSON.parse(res.body)
    version = json_data["Service"]["Version"]
    puts "Latest version: #{version}"
  else
    ohai "Failed to get version metadata"
    exit 1
  end

  # Assume MacOS, ARM
  use_arch = "arm64"
  $download_sha = json_data["ClientChecksums"]["ARCH_TYPE_MACOS_ARM64"]

  on_macos do
    on_intel do
      use_arch = "amd64"
      $download_sha = json_data["ClientChecksums"]["ARCH_TYPE_MACOS_AMD64"]
    end
  end

  $endorctl_file = "endorctl_#{version}_macos_#{use_arch}"
  $download_url = "https://api.endorlabs.com/download/endorlabs/#{version}/binaries/#{$endorctl_file}"

  # Download and install
  url "https://api.endorlabs.com/meta/version", :using => EndorDownloadStrategy
  sha256 $download_sha

  def install
     bin.install "#{$endorctl_file}" => "endorctl"
  end

  test do
    system "#{bin}/endorctl", "--version"
  end

end
