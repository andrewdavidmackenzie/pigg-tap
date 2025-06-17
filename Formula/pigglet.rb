class Pigglet < Formula
  desc "A CLI agent for interacting with local Raspberry Pi GPIO Hardware from piggui GUI"
  homepage "https://github.com/andrewdavidmackenzie/pigg/"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/pigglet-aarch64-apple-darwin.tar.xz"
      sha256 "e5c8407211ff57f4d458ee6494270b43d87a1a0e4831ac59b57c1461ec98689a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/pigglet-x86_64-apple-darwin.tar.xz"
      sha256 "62bf98cc04795bbcf0df9beb8ae35380eaeba56af57e3fe4a88d871e2c75f4e4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/pigglet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "71e7edbb127db01c774d847b13595bed3f88bba6c3a1ece31e80fd34ab9ade33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andrewdavidmackenzie/pigg/releases/download/0.7.2/pigglet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7454e9d0326f234f198b9c1111214b28ff4d8c7ebd61af57d05653d949461319"
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
    bin.install "pigglet" if OS.mac? && Hardware::CPU.arm?
    bin.install "pigglet" if OS.mac? && Hardware::CPU.intel?
    bin.install "pigglet" if OS.linux? && Hardware::CPU.arm?
    bin.install "pigglet" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
