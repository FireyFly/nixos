# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = (import ../../module-list.nix) ++ [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ./certs.nix ./webserver.nix ./xmpp.nix
  ];

  nix.maxJobs = 2;
  nixpkgs.config.allowUnfree = true; # for unrar
  nixpkgs.config.allowBroken = true; # for luaexpat, needed for prosody

  networking.hostName = "hagall";

  boot = {
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "/dev/vda";
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  };

  fileSystems."/" = {
    label = "hagall-root";
    fsType = "ext4";
  };

  swapDevices = [
    { label = "hagall-swap"; }
  ];

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
  networking.nameservers = [ "8.8.4.4" ];

  programs.mosh.enable = true;
  programs.tmux.enable = true;

  users.users.firefly.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9i8fs10/BjNEqFXD+3fQeQ0SuHnQx4WpuqUg4caeed firefly@as"
  ];

  # stateful data lock
  system.stateVersion = "20.03";
}
