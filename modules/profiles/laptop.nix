{ config, pkgs, lib, ... }:

let
  cfg = config.mine.profiles.common;

in {
  options = {
    mine.profiles.laptop.enable = lib.mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    hardware = {
      pulseaudio.enable = true;
      pulseaudio.support32Bit = true;
      bluetooth.enable = true;
    };

    services.xserver = {
      enable = true;
      libinput.enable = true;
    };

    # TODO: services.mpd

    services.logind.lidSwitch = "ignore";
    services.illum.enable = true;
    powerManagement.powertop.enable = true;

    # TODO: look into enabling TLP?

    programs.ssh.startAgent = true;
    programs.wireshark.enable = true;
  };
}
