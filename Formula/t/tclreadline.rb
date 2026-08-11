class Tclreadline < Formula
  desc "GNU Readline for interactive Tcl shells"
  homepage "https://github.com/flightaware/tclreadline"
  url "https://github.com/flightaware/tclreadline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "d14b1568b6db8cd51659e3cc476a1f45da2020434ebb90b4b0defbc424f05907"
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

  # Upstream forgot to bump AC_INIT for the v2.4.1 tag.
  # https://github.com/flightaware/tclreadline/pull/62
  patch do
    url "https://github.com/flightaware/tclreadline/commit/0d793fc3ac647af977400b5673121bffcd57f6e3.patch?full_index=1"
    sha256 "1b65a1df3cd81f12b4da30952bac5c65576675ac3d2ca4a2cb9da9fd56c6f83e"
  end

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
