{ lib
, copyPathToStore, writeText, writeShellScriptBin, symlinkJoin, linkFarm
# dependencies
, mpd
, package ? mpd
# options
  # structured mpd config
  # See mpd.conf(5) or https://www.musicpd.org/doc/html/user.html#configuration
, config ? {}
}:
  let
    toMpdConf = cfg:
      let
        convertEntry = k: v:
          if lib.isString v
            then ''${k} "${v}"''
          else if lib.isBool v
            then ''${k} "${if v then "yes" else "no"}"''
        # else if lib.isAttrs v
        #   then "${k} {\n${toMpdConf v}\n}"
          # TODO: allow cfg.audio_output.foo = { ... }
          # or maybe cfg.blocks.foo = { block = "audio_output"; ... }
          else
            throw "don't know how to serialize '${builtins.typeOf v}' to mpd conf";
      in
        lib.concatStringsSep "\n" (lib.mapAttrsToList convertEntry cfg);

    configFile = writeText "mpd.conf" (toMpdConf config);

    # TODO: handle state dirs

    binWrapper = writeShellScriptBin "mpd" ''
      set -e
      exec ${package}/bin/mpd ${configFile}
    '';

  in symlinkJoin {
    name = "mpd-customized";
    paths = [ binWrapper package ];
  }


