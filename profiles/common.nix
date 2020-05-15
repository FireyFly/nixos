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

    nix.trustedUsers = [ "root" "@wheel" ];
    nix.nixPath = [
      "nixpkgs=/etc/nixos/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    nixpkgs.overlays = [
      (import ../packages/overlay.nix)
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

    #-- networking ----------------------
    networking.networkmanager = {
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
      extraConfig = ''
        [connection-extra]
        ethernet.generate-mac-address-mask=FE:FF:FF:00:00:00
        wifi.generate-mac-address-mask=FE:FF:FF:00:00:00
      '';
    };

    #-- programs ------------------------
    programs.zsh.enable = true;
    programs.zsh.shellInit = ''
      eval "$(${pkgs.any-nix-shell}/bin/any-nix-shell zsh)"
    '';

    programs.ssh.askPassword = "";
    programs.mtr.enable = true;
    environment.systemPackages = with pkgs; [
      manpages
      # standard tools
      bc file htop psmisc tree
      # network
      bind finger_bsd lftp whois
      mosh wget
      # compression
      unzip zip
      #p7zip   # 2020-04-30: marked insecure (CVEs)
      #unrar   # nonfree
      # reveng etc
      hexd pixd colordiff vbindiff
      # useful tools
      w3m jq ripgrep xmlformat
      #mandoc
      j
      # etc
      vim_configurable
      git
    ];

    #-- users ---------------------------
    mine.enableUser = true;
  };
}
