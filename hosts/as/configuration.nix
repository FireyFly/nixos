# NixOS system configuration
# See nixos-help, configuration.nix(5)
{ config, pkgs, ... }:

let
  hardwareConfigPath = ./hardware-configuration.nix;
  myModuleList = import ../../modules/module-list.nix;

in {
  nixpkgs.config.allowUnfree = true;

  imports = [ hardwareConfigPath ] ++ myModuleList;

  networking.hostName = "as";

  mine.profiles.laptop.enable = true;
  mine.services.xserver.emitMediaKeyEvents = true;
  mine.enableSDR = true;

  #-- boot & hw -----------------------
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.supportedFilesystems = [ "ext4" ];
    supportedFilesystems = [ "ext4" ];
  };

  swapDevices = [
    { label = "swap"; }
  ];

  hardware.cpu.intel.updateMicrocode = true;

  #-- system packages -----------------------------------------------
  environment.systemPackages = with pkgs; [
    # for KDE applications
    kdeFrameworks.kxmlgui
    # for WoW
    wineWowPackages.staging
  ];

  #-- services etc --------------------------------------------------
  virtualisation.virtualbox.host.enable = true;

  services.xserver.videoDrivers = ["intel" "vesa" "modesetting" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?
}
