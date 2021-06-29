{ lib, ... }:

{
  boot.loader.grub.enable = false;

  boot.initrd.includeDefaultModules = lib.mkDefault false;
  # qemu-guest.nix list + virtiofs (TODO: maybe trim down a bit)
  boot.initrd.availableKernelModules = [ "virtiofs" "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

  boot.initrd.checkJournalingFS = lib.mkDefault false;

  # TODO: boot options, in particular boot.initrd

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=0755" ];
  };

  fileSystems."/nix/store" = {
    device = "nix-store";
    fsType = "virtiofs";
    neededForBoot = true;
  };

  networking.dhcpcd.enable = lib.mkDefault false;
  services.timesyncd.enable = lib.mkDefault false;
  systemd.suppressedSystemUnits = [
    # matches isContainer settings
    "systemd-journald-audit.socket"
    "sys-kernel-config.mount"
  ];

  # this might be a bad idea
# system.nssModules = lib.mkForce [];
# services.nscd.enable = false;

  # disable services and things that are enabled by default
  # TODO: more things
  environment.noXlibs = lib.mkDefault true;
  appstream.enable = lib.mkDefault false;
 #boot.hardwareScan = lib.mkDefault false;
  documentation.enable = lib.mkDefault false;
  fonts.fontconfig.enable = lib.mkDefault false;
 #networking.dhcpcd.enable = lib.mkDefault false;
 #powerManagement.enable = lib.mkDefault false;

  services.udisks2.enable = lib.mkDefault false;
}
