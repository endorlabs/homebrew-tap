require 'net/http'

class Endorctl < Formula

  homepage "https://github.com/endorlabs/homebrew-tap"
  desc "Endor Labs Homebrew Tap"

  url "https://api.endorlabs.com/meta/version"
  version "latest"

  def install

    # Version URI
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
    sha_value = json_data["ClientChecksums"]["ARCH_TYPE_MACOS_ARM64"]

    on_macos do
      on_intel do
        use_arch = "amd64"
        sha_value = json_data["ClientChecksums"]["ARCH_TYPE_MACOS_AMD64"]
      end
    end

    # Download URI
    endorctl_file = "endorctl_#{version}_macos_#{use_arch}"
    download_uri = URI("https://api.endorlabs.com/download/endorlabs/#{version}/binaries/#{endorctl_file}")

    http = Net::HTTP.new(download_uri.host, download_uri.port)
    http.use_ssl = true

    req = Net::HTTP::Get.new(download_uri)
    res = http.request(req)
    if res.is_a?(Net::HTTPSuccess)
      File.open("#{endorctl_file}", "wb") do |file|
        file.write(res.body)
      end
    else
      ohai "Failed to download binary"
      exit 1
    end
    sha256_value = `shasum -a 256 #{endorctl_file}`.split.first

    if sha256_value != sha_value
      ohai "Checksum mismatch: expected #{sha256_value}, got #{sha_value}"
      exit 1
    else
      bin.install "#{endorctl_file}" => "endorctl"
    end
  end

  test do
    system "#{bin}/endorctl", "--version"
  end

end
