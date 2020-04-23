# NixOS system configuration
# See nixos-help, configuration.nix(5)
{ config, pkgs, ... }:

let
  hardwareConfigPath = ./hardware-configuration.nix;
  myModuleList = import ../../module-list.nix;

in {
  nixpkgs.config.allowUnfreePredicate = (x: pkgs.lib.hasPrefix "ttf-envy-code-r" x.name);

  imports = [ hardwareConfigPath ] ++ myModuleList;

  networking.hostName = "kaun";

  mine.profiles.laptop.enable = true;
  mine.services.xserver.emitMediaKeyEvents = true;
  mine.enableSDR = true;

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

  hardware.cpu.intel.updateMicrocode = true;

  #-- services etc --------------------------------------------------
  # Enable PCSC-Lite (SmartCard r/w)
# services.pcscd.enable = true;
# services.pcscd.plugins = [ pkgs.ccid ];

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
