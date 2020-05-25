{ stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libucl";
  version = "0.8.1";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "libucl";
    rev = version;
    sha256 = "1h52ldxankyhbbm1qbqz1f2q0j03c1b4mig7343bs3mc6fpm18gf";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = let
    inherit (stdenv.lib) maintainers platforms licenses;
  in {
    description = "Universal configuration library parser";
    homepage = "https://github.com/vstakhov/libucl";
    maintainers = [ maintainers.FireyFly ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
