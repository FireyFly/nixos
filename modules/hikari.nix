{ config, lib, pkgs, ... }:

let
  cfg = config.programs.hikari;

in {
  options.programs.hikari = {
    enable = lib.mkEnableOption "hikari, a stacking/tiling Wayland compositor.";
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.hikari.source = "${pkgs.hikari}/bin/hikari";
    security.wrappers.hikari-unlocker.source = "${pkgs.hikari}/bin/hikari-unlocker";
  };
}
