self: super:

{
  # My own tools
  plaintext = self.callPackage ./plaintext {};
  up = self.callPackage ./up {};
  scrup = self.callPackage ./scrup {};

  # Fixes
  inspectrum = self.libsForQt5.callPackage ./inspectrum {};
}
