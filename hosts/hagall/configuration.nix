# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  hardwareConfigPath = ./hardware-configuration.nix;
  myModuleList = import ../../modules/module-list.nix;

in {
# nixpkgs.config.allowUnfreePredicate = (x: pkgs.lib.hasPrefix "unrar" x.name);
  nixpkgs.config.allowUnfree = true;

  imports = [ hardwareConfigPath ] ++ myModuleList;

  networking.hostName = "hagall"; # Define your hostname.

  # boot and hw
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  programs.mosh.enable = true;
  programs.tmux.enable = true;

  users.users = lib.mkIf config.mine.enableUser {
    firefly.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9i8fs10/BjNEqFXD+3fQeQ0SuHnQx4WpuqUg4caeed firefly@as"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

