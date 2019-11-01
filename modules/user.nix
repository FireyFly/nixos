{ config, pkgs, lib, ... }:

let
  cfg = config.mine.profiles.common;

in {
  options = {
    mine.enableUser = lib.mkEnableOption "firefly user";
  };

  config = lib.mkIf config.mine.enableUser {

    users.users.firefly = {
      isNormalUser = true;
      uid = 1000;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "audio"
        "video"
        "networkmanager"
        "dialout"
        "wireshark"
        "vboxusers"
      ];
      # TODO: openssh.authorizedKeys.keys
    };

    mine.users.users.firefly = {
      environment = {
      # MANPATH = "$HOME/.nix-profile/share/man:/";
        EDITOR = "vim";
      };
    };

  };
}
