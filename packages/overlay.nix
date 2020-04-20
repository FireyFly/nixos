self: super:

{
  # My own tools
  plaintext = self.callPackage ./plaintext {};
  up = self.callPackage ./up {};
  scrup = self.callPackage ./scrup {};

  # Other packages
  katarakt = self.libsForQt5.callPackage ./katarakt {};
  pangoterm = self.callPackage ./pangoterm {};

  # Fixes
  inspectrum = self.libsForQt5.callPackage ./inspectrum {};
}
