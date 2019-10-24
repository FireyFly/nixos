{ config, pkgs, lib, ... }:

{
  #-- networking ----------------------
  networking.networkmanager.enable = true;

  #-- hardware ------------------------
  hardware = {
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    bluetooth.enable = true;
  };

  #-- X11 -----------------------------
  services.xserver = {
    enable = true;
    # (X11) keyboard layout (TODO: firefly layout)
    layout = "se";
    xkbVariant = "dvorak";
    xkbOptions = "caps:escape";
    # (X11) trackpad
  # synaptics = {
  #   enable = true;
  #   accelFactor = "0.1";
  #   minSpeed = "1.2";
  #   maxSpeed = "2.5";
  #   twoFingerScroll = true;
  #   additionalOptions = ''
  #     Option "EmulateTwoFingerMinZ" "40"
  #     Option "EmulateTwoFingerMinW" "8"
  #   '';
  # };
    libinput = {
      enable = true;
      accelSpeed = "0.6";
      disableWhileTyping = true;
      tappingDragLock = false;
      # see xinput --list-props 11; encode 'libinput Accel Speed' -> 'Option "AccelSpeed"'
      additionalOptions = ''
        Option "TappingButtonMap" "lmr"
      '';
    };
    windowManager.herbstluftwm.enable = true;
  };

  # TODO: services.mpd

  #-- laptop --------------------------
  services.logind.lidSwitch = "ignore";
  services.illum.enable = true;
  powerManagement.powertop.enable = true;

  # TODO: look into enabling TLP?

  #-- programs ------------------------
  programs.ssh.startAgent = true;
  programs.wireshark.enable = true;

  #-- fonts ---------------------------
  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = [
    # pkgs.tewi-font
    # pkgs.envypn-font
      pkgs.ttf-envy-code-r
      pkgs.noto-fonts-emoji
    ];
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      monospace = [ "Envy Code R" "DejaVu Sans Mono" "Noto Color Emoji" ];
    };
  };
}
