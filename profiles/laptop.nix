{ config, pkgs, lib, ... }:

let
  cfg = config.mine.profiles.laptop;

in {
  options = {
    mine.profiles.laptop.enable = lib.mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    hardware = {
      pulseaudio.enable = true;
      pulseaudio.support32Bit = true;
      pulseaudio.package = pkgs.pulseaudioFull; # needed for bluetooth headphones
      bluetooth.enable = true;
    };

    services.xserver = {
      enable = true;
      libinput.enable = true;
    };

    services.pcscd = {
      enable = true;
    };

    services.interception-tools.enable = true;

    # TODO: services.mpd

    services.logind.lidSwitch = "ignore";
    services.illum.enable = true;
    powerManagement.powertop.enable = true;

    # TODO: look into enabling TLP?

    programs.ssh.startAgent = true;
    programs.wireshark.enable = true;

    environment.systemPackages = with pkgs; let
      when = cond: arr: if cond then arr else [];
    in [
      # cli tools
      scrup
      gnupg
      openssl
      sshfs-fuse
      youtube-dl
      # gui tools
      katarakt
      mpv
      wireshark-cli
      # hardware
      acpitool usbutils pciutils
      dfu-util lm_sensors smartmontools
      # development
      nodejs lua gdb python3 clang
      # music
      mpd mpc_cli ncmpcpp
      ponymix
    ] ++ when config.services.xserver.enable [
      pangoterm
      firefox
      feh
      scrot
      xclip
      pass
    ] ++ when config.programs.hikari.enable [
      alacritty
      firefox-wayland
      wl-clipboard
      imv
      pass-wayland
    ];

    # fonts
    fonts = {
      enableDefaultFonts = true;
      enableFontDir = true;
      fonts = with pkgs; [
        ttf-envy-code-r
        noto-fonts
        noto-fonts-cjk
        noto-fonts-extra
        noto-fonts-emoji
        unifont
        font-awesome
      ];
      fontconfig.enable = true;
      fontconfig.defaultFonts = {
        monospace = [ "Envy Code R" "DejaVu Sans Mono" "Noto Color Emoji" ];
      };
    };
  };
}
