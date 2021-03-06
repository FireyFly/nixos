{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver;
  cfgMine = config.mine.services.xserver;

in {
  options = {
    mine.services.xserver.emitMediaKeyEvents = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to emit key events for media keys (volup, voldown, mute) by
        listening to corresponding ACPI events and injecting keypress events.
        On some laptops this appears to be necessary in order to map them.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    # use DRI whenever possible
    hardware = {
      opengl.driSupport = true;
      opengl.driSupport32Bit = true;
      opengl.extraPackages32 = [ pkgs.pkgsi686Linux.libva ];
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
      enable = true;
      accelSpeed = "0.6";
      disableWhileTyping = true;
      tappingDragLock = false;
      # see xinput --list-props 11; encode 'libinput Accel Speed' -> 'Option "AccelSpeed"'
      additionalOptions = ''
        Option "TappingButtonMap" "lmr"
      '';
    };

    # forward media key events if desired
    services.acpid = let
      xdotool = "${pkgs.xdotool}/bin/xdotool";
    in if cfgMine.emitMediaKeyEvents then {
      enable = true;
      handlers = {
        volumeup = {
          event = "button/volumeup.*";
          action = "${xdotool} key XF86AudioRaiseVolume";
        };
        volumedown = {
          event = "button/volumedown.*";
          action = "${xdotool} key XF86AudioLowerVolume";
        };
        mute = {
          event = "button/mute.*";
          action = "${xdotool} key XF86AudioMute";
        };
      };
    } else {};

    # window manager
    services.xserver.windowManager.herbstluftwm.enable = true;

    environment.systemPackages = with pkgs; [ scrot xclip ];

  };
}
