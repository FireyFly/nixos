{ lib
, writeText, writeShellScriptBin, symlinkJoin
# dependencies
, alacritty
# options
  # structured alacritty config
, config ? {}
}:
  let
    configFile = writeText "alacritty.yml" (lib.generators.toYAML {} config);
    binWrapper = writeShellScriptBin "alacritty" ''
      set -e
      exec ${alacritty}/bin/alacritty --config-file ${configFile}
    '';

  in symlinkJoin {
    name = "alacritty-configured";
    paths = [ binWrapper alacritty ];
  }

