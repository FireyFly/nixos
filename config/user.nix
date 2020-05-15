{ config, pkgs, lib, ... }:

let
  filterNonNull = builtins.filter (x: x != null);
  ifX11 = x: if config.services.xserver.enable then x else null;

in {
  options = {
    mine.enableUser = lib.mkEnableOption "firefly user";
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
      "vboxusers"
    ];

    mine.users.users.firefly.environment = let
      _home = config.users.users.firefly.home;
      _config = "${_home}/local/config";
      _var = "${_home}/local/var";
      _cache = "${_home}/local/var/cache";
    in {
      EDITOR = "vim";

      XDG_CONFIG_HOME = _config;
      # $XDG_DATA_HOME in practice seems to mostly be used as a state
      # directory, so we point it to ~/local/var rather than ~/local/share
      XDG_DATA_HOME = _var;
      XDG_CACHE_HOME = _cache;

      XCOMPOSEFILE = "${_config}/X11/XCompose";
      XCOMPOSECACHE = "${_cache}/X11/compose";

      # this is slightly hacky since vim won't actually know this to be the
      # vimrc.  Doesn't set $MYVIMRC
      VIMINIT = "source ${_config}/vim/vimrc";

      # NB. read in profiles/laptop.nix
      MPD_CONF = "${_config}/mpd/mpd.conf";

      ZDOTDIR = "${_config}/zsh";
      MBLAZE = "${_var}/mblaze";
      LESSHISTFILE = "${_var}/less/history";
      GNUPGHOME = "${_var}/gnupg";
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
