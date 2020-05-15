self: super:


rec {
  plaintext = super.callPackage ./plaintext {};
  up = super.callPackage ./up {};
  scrup = super.callPackage ./scrup {};
  ucd = super.callPackage ./ucd {};
  charselect = super.callPackage ./charselect { inherit ucd; };

  katarakt = super.libsForQt5.callPackage ./katarakt {};
  libucl = super.callPackage ./libucl {};

  pangoterm = super.callPackage ./pangoterm {};
  jevalbot = super.callPackage ./jevalbot {};

  # Fixes
  inspectrum = self.libsForQt5.callPackage ./inspectrum {};

  # patch out the Esc->Caps transform (pass through Esc unchanged)
  interception-tools-plugins = super.interception-tools-plugins // {
    caps2esc = super.interception-tools-plugins.caps2esc.overrideAttrs (_: {
      prePatch = ''
        sed -i '
          /if (input.code == KEY_ESC)/ d
          /input.code = KEY_CAPSLOCK;/ d
        ' caps2esc.c
      '';
    });
  };
}
