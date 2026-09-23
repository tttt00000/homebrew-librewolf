cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "156.0.1,1"
  sha256 arm:   "d67ebcc8f3711b398979facfec9a5cf086fb055a81f8b95094bb2d81c9dc0061",
         intel: "97d83fdf212469178c082db7c02aaff51d4bc98b5980b85b9873f7e0a8a7bd8a"

  url "https://codeberg.org/api/packages/librewolf/generic/librewolf/#{version.tr(",", "-")}/librewolf-#{version.tr(",", "-")}-macos-#{arch}-package.dmg",
      verified: "codeberg.org/api/packages/librewolf/generic/librewolf/"
  name "LibreWolf"
  desc "Web browser"
  homepage "https://librewolf.net/"

  depends_on :macos

  app "LibreWolf.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/librewolf.wrapper.sh"
  binary shimscript, target: "librewolf"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/LibreWolf.app/Contents/MacOS/librewolf' "$@"
    EOS
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/LibreWolf.app"],
                   sudo: false
  end

  zap trash: [
    "~/.librewolf",
    "~/Library/Application Support/LibreWolf",
    "~/Library/Caches/LibreWolf Community",
    "~/Library/Caches/LibreWolf",
    "~/Library/Preferences/io.gitlab.librewolf-community.librewolf.plist",
    "~/Library/Saved Application State/io.gitlab.librewolf-community.librewolf.savedState",
  ]
end
