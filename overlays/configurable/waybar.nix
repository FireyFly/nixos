{ lib
, copyPathToStore, writeText, writeShellScriptBin, symlinkJoin, linkFarm
# dependencies
, waybar
# options
  # structured waybar config
, config ? {}
  # waybar stylesheet file
, stylesheetFile
}:
  let
    namePathPair = name: path: { inherit name path; };
    mkXdgConfigHome = files: linkFarm "xdg-config-home"
        (lib.mapAttrsToList namePathPair files);

    configFile = writeText "waybar-config" (lib.generators.toJSON {} config);
    xdgConfigHome = mkXdgConfigHome {
      "waybar/config" = configFile;
      "waybar/style.css" = copyPathToStore stylesheetFile;
    };

    binWaybarWrapper = writeShellScriptBin "waybar" ''
      set -e
      export XDG_CONFIG_HOME=${xdgConfigHome}
      exec ${waybar}/bin/waybar
    '';

  in symlinkJoin {
    name = "waybar-configured";
    paths = [ binWaybarWrapper waybar ];
  }

