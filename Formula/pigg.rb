class Pigg < Formula
  desc "A Graphical User Interface for interacting with local and remote Raspberry Pi and Pi Pico Hardware"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.5.0/pigg-aarch64-apple-darwin.tar.xz"
      sha256 "ea1677f689de453607c74ce7bd78a2374a879c3a5a5a87cd228f213fb3f3865e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.5.0/pigg-x86_64-apple-darwin.tar.xz"
      sha256 "cb0561d8531e21f917c5445a37b5366e97e2eba521881a78283bce5e0f9e7d03"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.5.0/pigg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "44c796efd539cfe01943d13098bbf3322bec1608f20185e3f087b8ffb59fbc1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.5.0/pigg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3854932274abca138b2bf5671abcf5a4c824ecd18e45bee32939ec43f153e521"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":                   {},
    "aarch64-unknown-linux-gnu":              {},
    "armv7-unknown-linux-gnueabihf":          {},
    "armv7-unknown-linux-musl-dynamiceabihf": {},
    "armv7-unknown-linux-musl-staticeabihf":  {},
    "x86_64-apple-darwin":                    {},
    "x86_64-pc-windows-gnu":                  {},
    "x86_64-unknown-linux-gnu":               {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "piggui", "piglet" if OS.mac? && Hardware::CPU.arm?
    bin.install "piggui", "piglet" if OS.mac? && Hardware::CPU.intel?
    bin.install "piggui", "piglet" if OS.linux? && Hardware::CPU.arm?
    bin.install "piggui", "piglet" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
