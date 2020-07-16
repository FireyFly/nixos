{ lib
, writeText, writeShellScript, writeShellScriptBin, symlinkJoin
# dependencies
, hikari, dbus
, package ? hikari
# options
  # structured hikari config
, config ? {}
  # shell commands for hikari to run upon startup
, autostartLines ? ""
  # shell commands to run before executing hikari
, sessionCommands ? ''
  export XDG_SESSION_TYPE=wayland
''
}:
  let
    configFile = writeText "hikari.conf" (lib.generators.toJSON {} config);
    autostartFile = writeShellScript "hikari-autostart" autostartLines;

    command = ''${package}/bin/hikari -a ${autostartFile} -c ${configFile} "$@"'';
    binWrapper = writeShellScriptBin "hikari" ''
      set -e
      ${sessionCommands}
      if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
        export DBUS_SESSION_BUS_ADDRESS
        exec ${command}
      else
        exec ${dbus}/bin/dbus-run-session ${command}
      fi
    '';

  in symlinkJoin {
    name = "hikari-customized";
    paths = [ binWrapper package ];
  }
