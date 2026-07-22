cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "153.0,1"
  sha256 arm:   "a08d1b9615c68d2e60808f7ea5d99aac5b8435a0820a9960d7833f2e66f1b652",
         intel: "76a132df5282e9b00b1bbb5753d3b4550fa7e46a0cdbcec6ff1322b1bff0a242"

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
