{ lib
, writeText, writeShellScriptBin, symlinkJoin
# dependencies
, alacritty
, package ? alacritty
# options
  # structured alacritty config
, config ? {}
}:
  let
    configFile = writeText "alacritty.yml" (lib.generators.toYAML {} config);
    binWrapper = writeShellScriptBin "alacritty" ''
      set -e
      exec ${package}/bin/alacritty --config-file ${configFile}
    '';

  in symlinkJoin {
    name = "alacritty-customized";
    paths = [ binWrapper package ];
  }

