class Erlang19Requirement < Requirement
  fatal true

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "19"])' -s erlang halt | grep -q '^true'`
    next unless $CHILD_STATUS.exitstatus.zero?
    erl
  end

  def message; <<~EOS
    Erlang 19+ is required to install. Elixir v1.7 is the last release to support Erlang/OTP 19. We recommend everyone to migrate to Erlang/OTP 20+.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      https://www.erlang.org/
    EOS
  end
end

class ElixirAT173 < Formula
  desc "A dynamic, functional language designed for building scalable and maintainable applications, built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.7.3.tar.gz"
  version "1.7.3"
  sha256 "c9beabd05e820ee83a56610cf2af3f34acf3b445c8fabdbe98894c886d2aa28e"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "2d9d5faee079949f780c8f6a1ccba015d64ecf859ed87384ae4239d69be60142" => :high_sierra
    sha256 "83e4a920d648d541288dd73b6cc19cb4d91a54e703609320e806c2efd6000466" => :sierra
    sha256 "88f24d7781e7191d94b39fc36464781385a314656bb6900f42cbd996654b579d" => :el_capitan
    sha256 "0d59995085bcdbdbfc08a6467ca99934598756b663c603cffc9103a96b36ff44" => :yosemite
  end

  depends_on Erlang19Requirement

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
