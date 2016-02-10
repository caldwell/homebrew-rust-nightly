require 'formula'
require 'date'

class RustNightly < Formula
  def self.latest_rust_nightly_revision
    @latest_rust_nightly_revision ||= begin
      Date.parse(`curl --silent --HEAD 'https://static.rust-lang.org/dist/rust-nightly-x86_64-apple-darwin.tar.gz' | grep 'Last-Modified:'`.split(' ', 2).last.strip).to_s
    end
  end

  def self.sha256_checksum
    `curl --silent 'https://static.rust-lang.org/dist/rust-nightly-x86_64-apple-darwin.tar.gz.sha256'`.split.first
  end

  homepage 'http://www.rust-lang.org/'
  url "https://static.rust-lang.org/dist/rust-nightly-x86_64-apple-darwin.tar.gz"
  sha256 sha256_checksum
  head 'https://github.com/rust-lang/rust.git'
  version "1.0-#{latest_rust_nightly_revision}"

  conflicts_with 'rust', :because => 'multiple version'

  def install
    system('./install.sh', "--prefix=#{prefix}")
  end

  test do
    system "#{bin}/rustc"
    system "#{bin}/rustdoc", "-h"
  end
end
