class Pigg < Formula
  desc "A Graphical User Interface for interacting with local and remote Raspberry Pi and Pi Pico Hardware"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.6.0/pigg-aarch64-apple-darwin.tar.xz"
      sha256 "6c65b1b062c7109f96f65f6def785341bdd113be968f86c478d0281d5d5d278a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.6.0/pigg-x86_64-apple-darwin.tar.xz"
      sha256 "f547abde4e6fb62b84ef19f31268e60ba339acc240e9ef4524e670cf6dcb57bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.6.0/pigg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "03de53ed7cb2f921729f026743ab453d0b34ef42d4f985154b57872db4d32677"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.6.0/pigg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "304496b8814f03b4ec532d969d4e8a7b6788624aec60f3e432d62fbb34057d5e"
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
