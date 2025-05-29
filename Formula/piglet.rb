class Piglet < Formula
  desc "A CLI agent for interacting with local Raspberry Pi GPIO Hardware from piggui GUI"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piglet-aarch64-apple-darwin.tar.xz"
      sha256 "8b2bc03b69f831a7a22c2da83cbc9ccf533c87910c9d7b7b438a00f6c4ab341c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piglet-x86_64-apple-darwin.tar.xz"
      sha256 "4c4eb2f1c997ade20ca591f07080185e67aee02af25ad1477dd276537578806f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piglet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4719a8cb13a4aa41e43ede58f9b0b7d08df7271dca800a81a1d01768660d6312"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.0/piglet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ae60e3e4620496125f49f5fe69d7d1db5a4f9b389471165d14da607e9d143d6d"
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
    bin.install "piglet" if OS.mac? && Hardware::CPU.arm?
    bin.install "piglet" if OS.mac? && Hardware::CPU.intel?
    bin.install "piglet" if OS.linux? && Hardware::CPU.arm?
    bin.install "piglet" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
