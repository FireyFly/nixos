# NixOS system configuration
# See nixos-help, configuration.nix(5)
{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../profiles/common.nix
    ../../profiles/laptop.nix
  ];

  networking.hostName = "as";

  #-- boot & hw -----------------------
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.supportedFilesystems = [ "ext4" ];
    supportedFilesystems = [ "ext4" ];

    blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  };

  swapDevices = [
    { label = "swap"; }
  ];

  #-- system packages -----------------------------------------------
  environment.systemPackages = with pkgs; [
    manpages # TODO: unnecessary?
    # shell
    zsh # TODO: unnecessary?
    # kernel modules
    rtl-sdr
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
