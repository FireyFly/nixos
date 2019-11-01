{ config, pkgs, lib, ... }:

let
  cfg = config.mine.profiles.common;

  # Creates an enable option *defaulting to ON*
  mkEnableOption' = name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable ${name}.";
      type = lib.types.bool;
    };

in {
  options = {
    mine.profiles.common.enable = mkEnableOption' "common profile";
  };

  config = lib.mkIf cfg.enable {
    documentation.dev.enable = true;

    # TODO: nix, nixpkgs configuration

    nixpkgs.overlays = [
      (import ../../packages/overlay.nix)
    ];

    boot.cleanTmpDir = lib.mkDefault true;

    #-- tty & locale --------------------
    i18n = {
      consoleFont = "Lat2-Terminus16";
      # TODO: ./path/to/dvorak-sv-firefly.map.gz
      consoleKeyMap = "dvorak-sv-a1";
      defaultLocale = "en_GB.UTF-8";
    };

    time.timeZone = "Europe/Stockholm";

    #-- services ------------------------
    services.openssh = {
      enable = true;
      permitRootLogin = lib.mkForce "no";
      passwordAuthentication = false;
    };

    #-- programs ------------------------
    programs.zsh.enable = true;
    environment.systemPackages = with pkgs; [
      w3m wget
    ];
  # environment.systemPackages = [ pkgs.manpages ];

    #-- users ---------------------------
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

    # TODO: environment.extraInit (XDG_CONFIG_DIR?)
  };
}
