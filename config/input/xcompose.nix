{ config, lib, ... }:

let
  enabled = config.services.xserver.enable || config.programs.hikari.enable;
  _cache = config.mine.directories.cache;

in {
  mine.users.users.firefly.environment = lib.mkIf enabled {
    XCOMPOSEFILE = ./XCompose;
    # TODO: mkdir -p this in an activation script
    XCOMPOSECACHE = "${_cache}/X11/compose";
  };
}
