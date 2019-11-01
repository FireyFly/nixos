{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver;

in {
  config = lib.mkIf cfg.enable {

    # use DRI whenever possible
    hardware = {
      opengl.driSupport = true;
      opengl.driSupport32Bit = true;
    };

    # keyboard
    services.xserver = {
      # (TODO: firefly layout)
      layout = "se";
      xkbVariant = "dvorak";
      xkbOptions = "caps:escape";
    };

    # trackpad (synaptics)
    services.xserver.synaptics = {
      accelFactor = "0.1";
      minSpeed = "1.2";
      maxSpeed = "2.5";
      twoFingerScroll = true;
      additionalOptions = ''
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
      '';
    };

    # trackpad (libinput)
    services.xserver.libinput = {
      accelSpeed = "0.6";
      disableWhileTyping = true;
      tappingDragLock = false;
      # see xinput --list-props 11; encode 'libinput Accel Speed' -> 'Option "AccelSpeed"'
      additionalOptions = ''
        Option "TappingButtonMap" "lmr"
      '';
    };

    # window manager
    services.xserver.windowManager.herbstluftwm.enable = true;

    # fonts
    fonts = {
      enableDefaultFonts = true;
      enableFontDir = true;
      fonts = with pkgs; [ ttf-envy-code-r noto-fonts-emoji ];
      fontconfig.enable = true;
      fontconfig.defaultFonts = {
        monospace = [ "Envy Code R" "DejaVu Sans Mono" "Noto Color Emoji" ];
      };
    };

  };
}
