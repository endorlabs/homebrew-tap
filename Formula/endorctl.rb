require 'net/http'

class Endorctl < Formula
  homepage "https://github.com/endorlabs/homebrew-tap"
  desc "Endor Labs Homebrew Tap"

  ENDORCTL_VERSION_URL = "https://api.endorlabs.com/meta/version"

  # Version check logic
  livecheck do
    url ENDORCTL_VERSION_URL
    strategy :json do |json|
      json["ClientVersion"]
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
  version version_json["ClientVersion"]

  arch     = Hardware::CPU.arm? ? "arm64" : "amd64"
  platform = OS.mac? ? "macos" : "linux"

  url "https://api.endorlabs.com/download/endorlabs/#{version}/binaries/endorctl_#{version}_#{platform}_#{arch}"
  sha256 version_json["ClientChecksums"]["ARCH_TYPE_#{platform.upcase}_#{arch.upcase}"]

  def install
    bin.install "endorctl_#{version}_#{OS.mac? ? "macos" : "linux"}_#{Hardware::CPU.arm? ? "arm64" : "amd64"}" => "endorctl"
  end

  test do
    system "#{bin}/endorctl", "--version"
  end
end