{ stdenv, lib, mkDerivation
, fetchFromGitHub
, cmake
, ilmbase, LAStools
, libGLU
, qt5
}:

mkDerivation rec {
  pname = "displaz";
  version = "0.4.0-unstable";

  src = fetchFromGitHub {
    owner = "c42f";
    repo = "displaz";
    # No new releases in years..
  # rev = "v${version}";
    rev = "8dfa82bdeb5e91df872b6fd7975762adb1815c32";
    sha256 = "0n4r3hm059sjaqxhc3ks5y5rcx6mkkhg0dqyyw1c6i2nz1rrflxa";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DLASLIB_INCLUDE_DIRS=${LAStools}/include/LASlib"
    "-DLASLIB_LIBRARY=${LAStools}/lib/LASlib/libLASlib.a"
  ];
  buildInputs = [
    ilmbase
    qt5.qtbase
    libGLU.dev
    # Or PDAL, Boost: DISPLAZ_USE_PDAL
    LAStools
  ];

  # TODO: appears to behave glitchy wrt re-renders, might be due to
  # GPU/wayland/...

  meta = {
    description = "A viewer for geospatial point clouds";
    homepage = "https://c42f.github.io/displaz/";
    maintainers = [ lib.maintainers.FireyFly ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
}
