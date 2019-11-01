# NixOS system configuration
# See nixos-help, configuration.nix(5)

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (x: pkgs.lib.hasPrefix "ttf-envy-code-r" x.name);

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ] ++ (import ../../modules/module-list.nix);

  networking.hostName = "kaun";

  mine.profiles.laptop.enable = true;

  #-- boot & hw -----------------------
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # driver issues with iwlwifi on thinkpad
  boot.extraModprobeConfig = ''
    options iwlwifi 11n_disable=1
    options iwlwifi swcrypto=1
  '';

  #-- services etc --------------------------------------------------
  # Enable PCSC-Lite (SmartCard r/w)
# services.pcscd.enable = true;
# services.pcscd.plugins = [ pkgs.ccid ];

  # TODO: doesn't work, because `hardware.pulseaudio.systemWide = false`
# services.acpid = {
#   enable = true;
#   handlers.volumeup = {
#     event = "button/volumeup.*";
#     action = "${pkgs.ponymix}/bin/ponymix increase -d 0 2";
#   };
#   handlers.volumedown = {
#     event = "button/volumedown.*";
#     action = "${pkgs.ponymix}/bin/ponymix increase -d 0 2";
#   };
#   handlers.mute = {
#     event = "button/mute.*";
#     action = "${pkgs.ponymix}/bin/ponymix toggle -d 0";
#   };
# };

  # Fomu USB rules
  services.udev.extraRules = ''
    # Fomu Hacker device
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5bf0", GROUP="users", MODE="0660"
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
