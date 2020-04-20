{ config, pkgs, lib, ... }:

let
  filterNonNull = builtins.filter (x: x != null);
  ifX11 = x: if config.services.xserver.enable then x else null;

in {
  options = {
    mine.enableUser = lib.mkEnableOption "firefly user";
  };

  config = lib.mkIf config.mine.enableUser {

    users.users.firefly = {
      isNormalUser = true;
      uid = 1000;
      shell = pkgs.zsh;
    };

    users.users.firefly.extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "dialout"
      "wireshark"
      "vboxusers"
    ];

    users.users.firefly.packages = with pkgs; filterNonNull [
      plaintext
      up
      (ifX11 scrup)
      (ifX11 katarakt)
      (ifX11 pangoterm)
    ];

    mine.users.users.firefly = {
      environment = {
      # MANPATH = "$HOME/.nix-profile/share/man:/";
        EDITOR = "vim";
      };
    };

  };
}
