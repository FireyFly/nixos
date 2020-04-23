# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cdf26ea5-57ab-4eea-ad6d-38b2ec2f8998";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/df230263-1ee2-434f-b369-c2942f1b912d"; }
    ];

  nix.maxJobs = lib.mkDefault 2;
}
