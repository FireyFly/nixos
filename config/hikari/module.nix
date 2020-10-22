{ config, lib, pkgs, ... }:

let
  cfg = config.programs.hikari;
  package = import ./default.nix { inherit pkgs; };

in {
  options.programs.hikari = {
    enable = lib.mkEnableOption "hikari, a stacking/tiling Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package pkgs.xwayland ];
    security.pam.services.hikari-unlocker = {};
  # security.pam.services.hikari-unlocker.text = "auth include login";
  # security.wrappers.hikari-unlocker.source = "${pkgs.hikari}/bin/hikari-unlocker";
    hardware.opengl.enable = lib.mkDefault true;
  };
}
