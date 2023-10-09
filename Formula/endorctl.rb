class Endorctl < Formula

  desc "Endor Labs CLI"

  homepage "https://github.com/endorlabs/homebrew-tap"

  version "v1.5.260"

  on_macos do
    on_arm do
      url "https://api.staging.endorlabs.com/download/endorlabs/#{version}/binaries/endorctl_#{version}_macos_arm64"
      sha256 "c169052a595e5b4e0c6eabaa719371da19b3e7e1d6fb18a9b771f8d4e8a9a8bf"
    end
    on_intel do
      url "https://api.staging.endorlabs.com/download/endorlabs/#{version}/binaries/endorctl_#{version}_macos_amd64"
      sha256 "0ef1ff4152cdede028017cda087b226c174631eaa966400f95aa66a924d1f50c"
    end
  end


  #license "MIT"

  def install
    on_macos do
      on_arm do
        bin.install "endorctl_#{version}_macos_arm64" => "endorctl"
      end
      on_intel do
        bin.install "endorctl_#{version}_macos_amd64" => "endorctl"
      end
    end
  end

  test do
    system "#{bin}/endorctl", "--version"
  end
end
