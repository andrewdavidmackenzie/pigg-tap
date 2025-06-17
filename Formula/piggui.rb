class Piggui < Formula
  desc "A Graphical User Interface for interacting with local and remote Raspberry Pi and Pi Pico Hardware"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/piggui-aarch64-apple-darwin.tar.xz"
      sha256 "2eae4baa6c10b94d360530be09d7382fcbbf475367a1d39b2cb7677dd1ff6ffe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/piggui-x86_64-apple-darwin.tar.xz"
      sha256 "37dffbc77347456c8c7974d7457c8c772b480093a6c8a79e1b876981e45dd96f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/piggui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "182bc568f685389f2c026f168c18f38e4ba53826e5d5b03589134b223ad69015"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/piggui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6a4cfa780b967a9b893c0d75e6f22fce4565846e9757ac81e83a2ae8e330f4f"
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
