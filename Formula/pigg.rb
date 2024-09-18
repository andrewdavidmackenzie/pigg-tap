class Pigg < Formula
  desc "A Graphical User Interface for interacting with local and remote Raspberry Pi Hardware"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-aarch64-apple-darwin.tar.xz"
      sha256 "05998275c9c314b3e4b6ce5206aa5e353d64019e4da16fe841936c9e753d0308"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-x86_64-apple-darwin.tar.xz"
      sha256 "b16a135b5100fcf6d1114c459f9dd85c9a8e474b96c2d17dedf3e4b93dbc484a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "07d6681ac8df794bdea79efa25b7ae13ea7638d8841a99bc2214daa6ad015b54"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.4.0/pigg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82a256752a6667daf3fbf6a47609b704cc73e424b5199a500dd2a25870948e96"
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
