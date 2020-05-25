{ stdenv
, mkDerivation
, fetchFromGitHub
, pkgconfig
, cmake
, boost
, fftwFloat
, qtbase
, gnuradio
, liquid-dsp
}:

mkDerivation {
  name = "inspectrum-unstable-2017-05-31";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "a89d1337efb31673ccb6a6681bb89c21894c76f7";
    sha256 = "1fvnr8gca25i6s9mg9b2hyqs0zzr4jicw13mimc9dhrgxklrr1yv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake
    qtbase
    fftwFloat
    boost
    gnuradio
    liquid-dsp
  ];

  meta = with stdenv.lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = https://github.com/miek/inspectrum;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
