{ config, pkgs, lib, ... }:

let
  enabled = config.services.xserver.enable || config.programs.hikari.enable;
  mkXkbFile = pkgs.callPackage ./mkXkbFile.nix {};

  firefly-xkb = mkXkbFile {
    name = "firefly.xkb";
    directories = [
      "${pkgs.xorg.xkeyboardconfig}/share/X11/xkb"
      # augment with custom symbols file
      (pkgs.runCommandNoCC "xkb" {} ''
        mkdir -p $out/symbols
        ln -s ${./firefly.symbols} $out/symbols/firefly
      '')
    ];
    symbols = [ "pc" "firefly" "inet(evdev)" ];
  };

in {
  services.xserver.layout = "firefly";
  services.xserver.extraLayouts.firefly = {
    description = "FireFly's custom layout";
    languages = [ "eng" ];
    symbolsFile = ./firefly.symbols;
  };

  # variables used with libxkbcommon (e.g. for wayland compositors)
  mine.users.users.firefly.environment = lib.mkIf enabled {
    XKB_DEFAULT_FILE = firefly-xkb;
    # closest approximation as fallback
    XKB_DEFAULT_LAYOUT = "se(dvorak)";
  };
}
