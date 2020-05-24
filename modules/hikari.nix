{ config, lib, pkgs, ... }:

let
  cfg = config.programs.hikari;
  inherit (lib) types;

in {
  options.programs.hikari = {
    enable = lib.mkEnableOption "hikari, a stacking/tiling Wayland compositor";

    extraSessionCommands = lib.mkOption {
      type = types.lines;
      default = ''
        export XDG_SESSION_TYPE=wayland
      '';
      example = ''
        export XDG_SESSION_TYPE=wayland
        export MOZ_ENABLE_WAYLAND=1
        export GDK_BACKEND=wayland
        # with qt5.qtwayland in systemPackages:
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      '';
      description = ''
        Shell commands to run before executing hikari, e.g. to export
        environment variables.
      '';
    };

    settings = lib.mkOption {
      # TODO: proper type
      type = types.unspecified;
      description = "structured hikari settings";
    };

    autostartLines = lib.mkOption {
      type = types.lines;
      default = "";
      description = "autostart commands for hikari to run upon startup";
    };
  };

  config = let
    wrapper = pkgs.writeShellScriptBin "hikari" ''
      set -e
      ${cfg.extraSessionCommands}
      if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
        export DBUS_SESSION_BUS_ADDRESS
        exec ${pkgs.hikari}/bin/hikari "$@"
      else
        exec ${pkgs.dbus}/bin/dbus-run-session ${pkgs.hikari}/bin/hikari "$@"
      fi
    '';

    configFile = pkgs.writeText "hikari.conf"
        (lib.generators.toJSON {} cfg.settings);

    autostartFile = pkgs.writeShellScript "hikari-autostart" cfg.autostartLines;

    # TODO: hook up to DM or create systemd unit for hikari instead
    hikariLaunch = pkgs.writeShellScriptBin "hikari-launch" ''
      exec ${wrapper}/bin/hikari -a ${autostartFile} -c ${configFile}
    '';

    hikariWrapped = pkgs.symlinkJoin {
      name = "hikari-wrapped";
      paths = [ wrapper pkgs.hikari hikariLaunch ];
    };

  in lib.mkIf cfg.enable {
    environment.systemPackages = [ hikariWrapped ];
    security.pam.services.hikari-unlocker = {};
  # security.pam.services.hikari-unlocker.text = "auth include login";
  # security.wrappers.hikari-unlocker.source = "${pkgs.hikari}/bin/hikari-unlocker";

    hardware.opengl.enable = lib.mkDefault true;
  };
}
