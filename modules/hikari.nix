{ config, lib, pkgs, ... }:

let
  cfg = config.programs.hikari;

in {
  options.programs.hikari = {
    enable = lib.mkEnableOption "hikari, a stacking/tiling Wayland compositor.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.hikari ];
  # security.wrappers.hikari-unlocker.source = "${pkgs.hikari}/bin/hikari-unlocker";
    hardware.opengl.enable = true;
  };
}
