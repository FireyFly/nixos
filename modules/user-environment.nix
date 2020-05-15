{ config, lib, utils, pkgs, ... }:

let
  t = lib.types;
  cfg = config.mine.users;

  exportStringOf = vars:
    let
      exportStringOfOne = n: v: ''export ${n}="${lib.concatStringsSep ":" v}"'';
      exportVariables = lib.mapAttrsToList exportStringOfOne (lib.mapAttrs (n: lib.toList) vars);
    in
      lib.concatStringsSep "\n" exportVariables;

  userOpts = {
    options = {

      environment = lib.mkOption {
        default = {};
        type = t.attrsOf (t.either t.str (t.listOf t.str));
        apply = lib.mapAttrs (n: v: if lib.isList v then lib.concatStringsSep ":" v else v);
        example = { EDITOR = "nvim"; };
        description = ''
          A set of user-specific environment variables to be bound during
          shell initialisation (sourced from /etc/profile).
          The value of each variable can be either a string or a list of
          strings.  The latter is concatenated, interspersed with colon
          characters.
        '';
      };

    };
  };

in {

  options = {

    mine.users.users = lib.mkOption {
      default = {};
      type = t.loaOf (t.submodule userOpts);
      example = {
        alice = {
          environment = { EDITOR = "nvim"; };
        };
      };
      description = ''
        Additional user-level configuration enhancements.
      '';
    };

  };

  config = let
    initScript = ''
      # setup user-specific environment variables
      if [ -z "$__NIXOS_USER_ENV_DONE" ]; then
        if [ -e "/etc/environments/per-user/$USER" ]; then
          . "/etc/environments/per-user/$USER"
          __NIXOS_USER_ENV_DONE=1
        fi
      fi
    '';
  in {
    environment.etc =
      (lib.mapAttrs' (name: { environment, ... }: {
        name = "environments/per-user/${name}";
        value.text = ''
        # DO NOT EDIT -- this file has been generated automatically.

        ${exportStringOf environment}
        '';
      }) (lib.filterAttrs (_: u: u.environment != {}) cfg.users));

    environment.extraInit = initScript;
    environment.shellInit = initScript;
  };

}
