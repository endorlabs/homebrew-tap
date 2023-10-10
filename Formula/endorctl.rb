
class Endorctl < Formula

  desc "Endor Labs CLI"

  homepage "https://github.com/endorlabs/homebrew-tap"

  version "v1.5.259"

  on_macos do
    on_arm do
      url "https://api.staging.endorlabs.com/download/endorlabs/#{version}/binaries/endorctl_#{version}_macos_arm64"
      sha256 "3b87c4d2472567cdb8afe781d88963b630d460cfdd456bd222172ffd02c47608"
    end
    on_intel do
      url "https://api.staging.endorlabs.com/download/endorlabs/#{version}/binaries/endorctl_#{version}_macos_amd64"
      sha256 "870748b1e8463d92374d5863e0daee9c0780d1890adfa294fc42af0e2b71ab40"
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
