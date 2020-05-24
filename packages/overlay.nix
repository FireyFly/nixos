self: super:

rec {
  plaintext = super.callPackage ./plaintext {};
  up = super.callPackage ./up {};
  scrup = super.callPackage ./scrup {};
  charselect = super.callPackage ./charselect {};

  mpc-helper = super.writeShellScriptBin "mpc-helper" ''
    fmt='[%artist% - ][%title%|%file%]'
    case "$1" in
      grab) ${self.mpc_cli}/bin/mpc -f "$fmt" current >>$HOME/media/music/grabs ;;
      copy) ${self.mpc_cli}/bin/mpc -f "$fmt" current | ${self.wl-clipboard}/bin/wl-copy ;;
      *) echo >&2 "$0: unknown command $1"; exit 1 ;;
    esac
  '';

  katarakt = super.libsForQt5.callPackage ./katarakt {};
  libucl = super.callPackage ./libucl {};

  hikari = let
    package = super.callPackage ./hikari { inherit libucl; };
  in package.overrideAttrs ({ pname, ... }: {
    version = "dev";
    src = super.fetchdarcs {
      url = "https://hub.darcs.net/raichoo/${pname}";
      hash = "eea7c188874d96e90a163531fa4d782759e1eb33";
      sha256 = "07nnf291d8d51rwhvyifjxakmy3z3f4w4dpc4xm8cmbmma59axwr";
    };
  });

  pangoterm = super.callPackage ./pangoterm {};
  jevalbot = super.callPackage ./jevalbot {};

  # Fixes
  inspectrum = self.libsForQt5.callPackage ./inspectrum {};

  waybar = super.waybar.override {
    pulseSupport = true;
    swaySupport = false;
  };

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
