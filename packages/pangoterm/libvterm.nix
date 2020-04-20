{ stdenv, fetchbzr,
  perl, libtool, pkgconfig,
}:

with stdenv.lib;

# mostly borrows from neovim-libvterm in the neovim package
stdenv.mkDerivation rec {
  name = "pangoterm-libvterm-${version}";
  version = "767";

  src = fetchbzr {
    url = "http://bazaar.leonerd.org.uk/c/libvterm/";
    rev = version;
    sha256 = "0b8jpzgghw6n6lflq27hgz5ds0qibf52yzyxb09yi1j5ry2qsf6q";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ libtool pkgconfig ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator.";
    homepage = "http://www.leonerd.org.uk/code/libvterm/";
    maintainers = [ maintainers.FireyFly ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
