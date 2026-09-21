class Tclreadline < Formula
  desc "GNU Readline for interactive Tcl shells"
  homepage "https://github.com/flightaware/tclreadline"
  url "https://github.com/flightaware/tclreadline/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "4d1f3b210062f4daf6dec084db37630bfd2cc923efe97d4e04aa4dea9758114d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "readline"
  depends_on "tcl-tk"

  def install
    readline = Formula["readline"]
    tcltk = Formula["tcl-tk"]

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-tcl=#{tcltk.opt_lib}",
                          "--with-tk=no",
                          "--with-readline-includes=#{readline.opt_include}",
                          "--with-readline-library=-L#{readline.opt_lib} -lreadline"
    system "make", "install"
  end

  test do
    ENV["TCLLIBPATH"] = lib.to_s
    tclsh = formula_opt_bin("tcl-tk")/"tclsh"
    assert_equal version.to_s,
                 pipe_output(tclsh, "puts [package require tclreadline]\n").strip
  end
end
