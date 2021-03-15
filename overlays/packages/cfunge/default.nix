{ stdenv, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "cfunge";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "VorpalBlade";
    repo = "cfunge";
    rev = version;
    sha256 = "18ir0h10vxdb5jb57w5hjbgi8spjxg9x2148agadhhmbhsja02m7";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A fast Befunge93/98 interpreter in C";
    maintainers = [ lib.maintainers.FireyFly ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
}
