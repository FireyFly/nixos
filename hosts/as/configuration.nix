# NixOS system configuration
# See nixos-help, configuration.nix(5)
{ config, pkgs, ... }:

{
  imports = import ../../module-list.nix;

  nix.maxJobs = 4;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "as";

  mine.profiles.laptop.enable = true;
  mine.services.xserver.emitMediaKeyEvents = true;
  mine.enableSDR = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.supportedFilesystems = [ "ext4" ];

    kernelModules = [ "kvm-intel" ];
    supportedFilesystems = [ "ext4" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-rootfs";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0AF3-24F0";
    fsType = "vfat";
  };

  swapDevices = [
    { label = "swap"; }
  ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = "powersave";

  environment.systemPackages = [
    # for KDE applications
    pkgs.kdeFrameworks.kxmlgui
  ];

  virtualisation.virtualbox.host.enable = true;

  services.xserver.videoDrivers = ["intel" "vesa" "modesetting" ];

  # stateful data lock
  system.stateVersion = "17.09";
}
