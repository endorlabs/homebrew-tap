require 'net/http'

class Endorctl < Formula
  homepage "https://github.com/endorlabs/homebrew-tap"
  desc "Endor Labs Homebrew Tap"

  ENDORCTL_VERSION_URL = "https://api.endorlabs.com/meta/version"

  # Version check logic
  livecheck do
    url ENDORCTL_VERSION_URL
    strategy :json do |json|
      json["Service"]["Version"]
    end
  end

  def self.fetch_version_json
    uri = URI(ENDORCTL_VERSION_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    if res.is_a?(Net::HTTPSuccess)
      version_json = JSON.parse(res.body)
      version_json
    else
      odie "Failed to get version metadata"
    end
  end

  version_json = fetch_version_json
  version version_json["Service"]["Version"]

  # Assume MacOS, ARM
  use_arch = "arm64"
  $download_sha = version_json["ClientChecksums"]["ARCH_TYPE_MACOS_ARM64"]

  on_macos do
    on_intel do
      use_arch = "amd64"
      $download_sha = version_json["ClientChecksums"]["ARCH_TYPE_MACOS_AMD64"]
    end
  end
  
  $endorctl_file = "endorctl_#{version}_macos_#{use_arch}"
  $download_url = "https://api.endorlabs.com/download/endorlabs/#{version}/binaries/#{$endorctl_file}" 
  
  # Download properties
  url $download_url
  sha256 $download_sha
  
  def install
     bin.install "#{$endorctl_file}" => "endorctl"
  end

  test do
    system "#{bin}/endorctl", "--version"
  end

end