class Libksi < Formula
  desc "KSI C SDK"
  homepage "https://guardtime.github.io/libksi/"
  url "https://github.com/guardtime/libksi/archive/v3.16.2473.tar.gz"
  sha256 "115f2c804b9ba0fb3fb9f313bd21b6d9bb3d9c88356dc5727f000c20f4d4147c"

  head do
    url "https://github.com/guardtime/libksi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  # Release tarball misses configure/make scripts
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # system "autoreconf", "-if" if build.head?
    system "autoreconf", "-if"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ksi/ksi.h>
      #include <assert.h>
      int main()
      {
        KSI_CTX *ksi = NULL;
        assert(KSI_CTX_new(&ksi) == KSI_OK);
        KSI_CTX_free(ksi);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lksi", "-o", "test"
    system "./test"
  end
end
