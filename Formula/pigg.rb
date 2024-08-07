class Pigg < Formula
  desc "A Graphical User Interface for interacting with local and remote Raspberry Pi Hardware"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.3.4/pigg-aarch64-apple-darwin.tar.xz"
      sha256 "4b7d4bff3d1dfbb7e8f99bae58ee7c971ee340aac7cc958d5dbc3e65ee62b2a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.3.4/pigg-x86_64-apple-darwin.tar.xz"
      sha256 "d99b25012c53d1f39a74eeaa5054a947e80275599f28108b3e3d438d95cdbccc"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.3.4/pigg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d41aa0ff3a3de491681d2c13b5a9d12ddf66931963dabd10468981e19d99c718"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "piggui", "piglet"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "piggui", "piglet"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "piggui", "piglet"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
