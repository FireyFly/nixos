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
    console = {
      font = "Lat2-Terminus16";
      # TODO: ./path/to/dvorak-sv-firefly.map.gz
      keyMap = "dvorak-sv-a1";
    };

    i18n.defaultLocale = "en_GB.UTF-8";
    time.timeZone = "Europe/Stockholm";

    #-- services ------------------------
    services.openssh = {
      enable = true;
      permitRootLogin = lib.mkForce "no";
      passwordAuthentication = false;
    };

    #-- programs ------------------------
    programs.zsh.enable = true;
    programs.ssh.askPassword = "";
    environment.systemPackages = with pkgs; [
      # standard tools
      bc file htop psmisc tree
      # network
      bind finger_bsd lftp mtr whois
      mosh wget
      # compression
      p7zip unrar unzip zip
      # reveng etc
      hexd pixd colordiff vbindiff
      # useful tools
      w3m jq ripgrep xmlformat
      mandoc
      j
    ];

    #-- users ---------------------------
    mine.enableUser = true;
  };
}
