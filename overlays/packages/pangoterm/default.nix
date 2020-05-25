{ stdenv, fetchbzr,
  perl, libtool, pkgconfig,
  glib, cairo, gtk2,
}:

let
  inherit (stdenv.lib) maintainers licenses platforms;

  libvterm = import ./libvterm.nix { inherit stdenv fetchbzr perl libtool pkgconfig; };

in stdenv.mkDerivation rec {
  name = "pangoterm-${version}";
  version = "616";

  src = fetchbzr {
    url = "http://bazaar.leonerd.org.uk/code/pangoterm/";
    rev = version;
    sha256 = "08giyl5xzm70x53bqdxhhnwnz54v5s2i350scln4w546ibnvsarb";
  };

  buildInputs = [ glib libvterm cairo gtk2 ];
  nativeBuildInputs = [ libtool pkgconfig ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A GTK/Pango-based terminal that uses libvterm to provide terminal emulation.";
    homepage = "http://www.leonerd.org.uk/code/pangoterm/";
    maintainers = [ maintainers.FireyFly ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
