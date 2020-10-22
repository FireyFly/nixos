{ config, pkgs, lib, ... }:

let
  filterNonNull = builtins.filter (x: x != null);
  ifX11 = x: if config.services.xserver.enable then x else null;

  inherit (lib) types;

  mkDirectoryOption = name: lib.mkOption {
    type = types.str;
    description = "${name} directory";
  };

in {
  options = {
    mine.enableUser = lib.mkEnableOption "firefly user";
    mine.directories.config = mkDirectoryOption "XDG config";
    mine.directories.data = mkDirectoryOption "XDG data";
    mine.directories.cache = mkDirectoryOption "XDG cache";
  };

  config = lib.mkIf config.mine.enableUser {

    users.users.firefly = {
      isNormalUser = true;
      uid = 1000;
      shell = pkgs.zsh;
    };

    users.users.firefly.extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "dialout"
      "wireshark"
    ] ++ lib.optional config.services.printing.enable "lp"
      ++ lib.optional config.hardware.sane.enable "scanner"
      ++ lib.optional config.virtualisation.virtualbox.host.enable "vboxusers";

    mine.directories = let
      _home = config.users.users.firefly.home;
    in {
      config = "${_home}/local/config";
      data = "${_home}/local/var";
      cache = "${_home}/local/var/cache";
    };

    mine.users.users.firefly.environment = let
      _home = config.users.users.firefly.home;
      _config = config.mine.directories.config;
      _var = config.mine.directories.data;
      _cache = config.mine.directories.cache;
    in {
      EDITOR = "vim";

      XDG_CONFIG_HOME = _config;
      # $XDG_DATA_HOME in practice seems to mostly be used as a state
      # directory, so we point it to ~/local/var rather than ~/local/share
      XDG_DATA_HOME = _var;
      XDG_CACHE_HOME = _cache;

      # NB. read in profiles/laptop.nix
      MPD_CONF = "${_config}/mpd/mpd.conf";

      ZDOTDIR = "${_config}/zsh";
      MBLAZE = "${_var}/mblaze";
      LESSHISTFILE = "${_var}/less/history";
    # GNUPGHOME = "${_var}/gnupg";
      WEECHAT_HOME = "${_var}/weechat";

      PULSE_COOKIE = "${_var}/pulse/cookie";
      NODE_REPL_HISTORY = "${_var}/node/history";

      BZR_LOG = "${_var}/log/bzr.log";
      MONO_REGISTRY_PATH = "${_var}/mono/registry";
      GRADLE_USER_HOME = "${_var}/gradle";
      __GL_SHADER_DISK_CACHE_PATH = "${_cache}/nvidia/GLCache";
    };

  };
}
