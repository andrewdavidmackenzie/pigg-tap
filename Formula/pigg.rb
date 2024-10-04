class Pigg < Formula
  desc "A Graphical User Interface for interacting with local and remote Raspberry Pi Hardware"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-aarch64-apple-darwin.tar.xz"
      sha256 "e861dc9d7f8b388459e0d8c36da42b5ef1df9fec314e4772b70435f29dd5f760"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-x86_64-apple-darwin.tar.xz"
      sha256 "02b0e2d333385fd7fea7109b60c355a82bea959635b08974b4766acae92f6376"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a789832c70bce5451327688d75017f4f93b4822029104bd0c7a1ec7f01248aa8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "da1befbfe3f704788d91a7e34701646ffa4569bdcd40e8984d5b732462a0e64c"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":          {},
    "aarch64-unknown-linux-gnu":     {},
    "armv7-unknown-linux-gnueabihf": {},
    "x86_64-apple-darwin":           {},
    "x86_64-pc-windows-gnu":         {},
    "x86_64-unknown-linux-gnu":      {},
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
