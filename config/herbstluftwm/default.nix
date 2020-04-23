{ config, pkgs, ... }:

let
  cfg = config.services.xserver.windowManager.herbstluftwm;

in {
  config = {
    services.xserver.windowManager.herbstluftwm.configFile =
      if cfg.enable
      then pkgs.callPackage ./autostart.nix {}
      else null;
  };
}
