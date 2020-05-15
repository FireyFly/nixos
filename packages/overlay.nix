self: super:


rec {
  plaintext = super.callPackage ./plaintext {};
  up = super.callPackage ./up {};
  scrup = super.callPackage ./scrup {};
  ucd = super.callPackage ./ucd {};
  charselect = super.callPackage ./charselect { inherit ucd; };

  katarakt = super.libsForQt5.callPackage ./katarakt {};
  pangoterm = super.callPackage ./pangoterm {};
  jevalbot = super.callPackage ./jevalbot {};

  # Fixes
  inspectrum = self.libsForQt5.callPackage ./inspectrum {};
}
