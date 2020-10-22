{ config, pkgs, lib, ... }:

let
  cfg = config.mine.profiles.gaming;

in {
  options = {
    mine.profiles.gaming.enable = lib.mkEnableOption "gaming profile";
  };

  config = lib.mkIf cfg.enable {

    hardware.opengl.enable = true;
    hardware.opengl.extraPackages = [
      pkgs.libGL  # mesa
    ];

    hardware.opengl.driSupport32Bit = true;
    hardware.pulseaudio.support32Bit = true;

    environment.systemPackages = [
      pkgs.steam
    ];

    services.xserver.enable = true;

  };
}
