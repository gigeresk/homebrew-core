class Tclreadline < Formula
  desc "GNU Readline for interactive Tcl shells"
  homepage "https://github.com/flightaware/tclreadline"
  url "https://github.com/flightaware/tclreadline/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "306f9a72ef3ad9ff7a8549f1c616edef5365b98bce7e62fdde6e595355c0faee"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "readline"
  depends_on "tcl-tk@8"

  def install
    tcl = Formula["tcl-tk@8"]
    readline = Formula["readline"]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-tcl=#{tcl.opt_lib}",
                          "--with-tk=no",
                          "--with-readline-includes=#{readline.opt_include}",
                          "--with-readline-library=-L#{readline.opt_lib} -lreadline"
    system "make", "install"
  end

  test do
    ENV["TCLLIBPATH"] = lib
    tclsh = Formula["tcl-tk@8"].opt_bin/"tclsh"
    assert_equal version.to_s,
                 shell_output("#{tclsh} <<<'puts [package require tclreadline]'").strip
  end
end
