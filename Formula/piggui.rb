class Piggui < Formula
  desc "A Graphical User Interface for interacting with local and remote Raspberry Pi and Pi Pico Hardware"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piggui-aarch64-apple-darwin.tar.xz"
      sha256 "f37814ddbce64a9c8ca544ff403c4bb81eb32b35f178a73b65485c5f60b5e6bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piggui-x86_64-apple-darwin.tar.xz"
      sha256 "b63a55021151f173ee4138a45e86a3b9a58415955ca75b75f54106fda078847e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piggui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "154873fd476007e1655e9ed0072ee0d00e12e7656585e032bc0b4ed417365440"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piggui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b18e88f9e06434d00aec32954b0cb7fbb4b1aa5e0e7bd6d97aab2203879606d4"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":                   {},
    "aarch64-unknown-linux-gnu":              {},
    "arm-unknown-linux-gnueabihf":            {},
    "arm-unknown-linux-musl-dynamiceabihf":   {},
    "arm-unknown-linux-musl-staticeabihf":    {},
    "armv7-unknown-linux-gnueabihf":          {},
    "armv7-unknown-linux-musl-dynamiceabihf": {},
    "armv7-unknown-linux-musl-staticeabihf":  {},
    "x86_64-apple-darwin":                    {},
    "x86_64-pc-windows-gnu":                  {},
    "x86_64-unknown-linux-gnu":               {},
    "x86_64-unknown-linux-musl-dynamic":      {},
    "x86_64-unknown-linux-musl-static":       {},
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
    bin.install "piggui" if OS.mac? && Hardware::CPU.arm?
    bin.install "piggui" if OS.mac? && Hardware::CPU.intel?
    bin.install "piggui" if OS.linux? && Hardware::CPU.arm?
    bin.install "piggui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
