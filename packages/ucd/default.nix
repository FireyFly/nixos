{ stdenv, fetchzip, ... }:

stdenv.mkDerivation rec {
  pname = "ucd";
  version = "13.0.0";

  src = fetchzip {
    url = "https://www.unicode.org/Public/zipped/${version}/UCD.zip";
    sha256 = "1jn8617ai6dh22c3zmad5g617lppzzjcrynl70jw1ld47ihbgzp3";
    stripRoot = false;
  };

  installPhase = ''
    mkdir $out
    mv * $out
  '';
}
