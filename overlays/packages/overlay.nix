self: super:

rec {
  plaintext = super.callPackage ./plaintext {};
  up = super.callPackage ./up {};
  scrup = super.callPackage ./scrup {};
  charselect = super.callPackage ./charselect {};

  katarakt = super.libsForQt5.callPackage ./katarakt {};

  displaz = super.libsForQt5.callPackage ./displaz {};

  cfunge = super.callPackage ./cfunge {};

  lywsd03mmc-exporter = super.callPackage ./lywsd03mmc-exporter {};

  pangoterm = super.callPackage ./pangoterm {};
  jevalbot = super.callPackage ./jevalbot {};

  # Fixes
  inspectrum = self.libsForQt5.callPackage ./inspectrum {};
}
