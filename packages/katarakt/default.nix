{ stdenv, mkDerivation
, fetchFromGitLab
, qmake, pkgconfig
, qtbase, poppler
}:

let
  inherit (stdenv.lib) maintainers platforms licenses;

in mkDerivation rec {
  pname = "katarakt";
  version = "0.2";

  src = fetchFromGitLab {
    domain = "gitlab.cs.fau.de";
    owner = "Qui_Sum";
    repo = "katarakt";
    rev = "v${version}";
    sha256 = "0sy4l8ai7ccnm5fgbsynp845s8x8zaidfim1g6i9qygv279cnndc";
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [
    qtbase
    poppler
  ];

  postInstall = ''
    mkdir -p $out/bin
    mv katarakt $out/bin/
  '';

  meta = {
    description = "Very simple keyboard-driven PDF viewer";
    homepage = "https://gitlab.cs.fau.de/Qui_Sum/katarakt";
    maintainers = [ maintainers.FireyFly ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
