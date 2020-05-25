self: super:

rec {
  plaintext = super.callPackage ./plaintext {};
  up = super.callPackage ./up {};
  scrup = super.callPackage ./scrup {};
  charselect = super.callPackage ./charselect {};

  katarakt = super.libsForQt5.callPackage ./katarakt {};
  libucl = super.callPackage ./libucl {};

  hikari = super.callPackage ./hikari { inherit libucl; };
# hikari = let
#   package = super.callPackage ./hikari { inherit libucl; };
# in package.overrideAttrs ({ pname, patches ? [], ... }: {
#   version = "dev";
#   src = super.fetchdarcs {
#     url = "https://hub.darcs.net/raichoo/${pname}";
#     hash = "4a353f9db2deb9a8448454e57466e05127ccfbeb";
#     sha256 = "1szkqskzc9i3la792sr3ljk0bplj22vlf3qmlw852dd9mskzm8x0";
#   };
#   patches = patches ++ [ ./hikari.patch ];
# });

  pangoterm = super.callPackage ./pangoterm {};
  jevalbot = super.callPackage ./jevalbot {};

  # Fixes
  inspectrum = self.libsForQt5.callPackage ./inspectrum {};

# waybar = super.waybar.override {
#   pulseSupport = true;
#   swaySupport = false;
# };

# # patch out the Esc->Caps transform (pass through Esc unchanged)
# interception-tools-plugins = super.interception-tools-plugins // {
#   caps2esc = super.interception-tools-plugins.caps2esc.overrideAttrs (_: {
#     prePatch = ''
#       sed -i '
#         /if (input.code == KEY_ESC)/ d
#         /input.code = KEY_CAPSLOCK;/ d
#       ' caps2esc.c
#     '';
#   });
# };
}
