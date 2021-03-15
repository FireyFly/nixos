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

    programs.hikari.enable = true;

    services.pcscd.enable = true;
    services.interception-tools.enable = true;

    # TODO: services.mpd

    services.logind.lidSwitch = "ignore";
    services.illum.enable = true;
    powerManagement.powertop.enable = true;

    # TODO: look into enabling TLP?

    programs.ssh.startAgent = true;
    programs.wireshark.enable = true;

    programs.gnupg.agent.enable = true;
    programs.gnupg.agent.pinentryFlavor = "gnome3";

    environment.systemPackages = with pkgs; let
      when = cond: arr: if cond then arr else [];
      hasX11 = config.services.xserver.enable;
      hasWayland = config.programs.hikari.enable;
    in [
      # cli tools
      scrup
    # gnupg
      openssl
      sshfs-fuse
      youtube-dl
      # gui tools
      mpv
      wireshark-cli
      # hardware
      acpitool usbutils pciutils
      dfu-util lm_sensors smartmontools
      # development
      nodejs lua gdb python3 clang
      # music
      (import ../config/mpd { inherit pkgs; })
      mpc_cli ncmpcpp
      ponymix
      # other applications
      dino
    ] ++ when hasX11 [
      pangoterm
      katarakt
      feh
      scrot
      xclip
    ] ++ when hasWayland [
      (import ../config/alacritty { inherit pkgs; })
      wl-clipboard
      imv
      grim
    ] ++ when (hasX11 or hasWayland) [
      firefox-wayland
      pass-wayland
    ];

    # fonts
    fonts = {
      enableDefaultFonts = true;
      enableFontDir = true;
      fonts = with pkgs; [
        iosevka
        noto-fonts
        noto-fonts-cjk
        noto-fonts-extra
        noto-fonts-emoji
        unifont
        font-awesome
      ];
      fontconfig.enable = true;
      fontconfig.defaultFonts = {
        monospace = [
          "Iosevka"
          "DejaVu Sans Mono"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
