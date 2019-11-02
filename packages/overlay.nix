self: super:

{
  plaintext = self.callPackage ./plaintext {};
  up = self.callPackage ./up {};
  scrup = self.callPackage ./scrup {};
}
