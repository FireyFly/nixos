{ config, lib, pkgs, ... }:

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
        type = t.attrsOf (t.oneOf [
          t.path
          t.str
          (t.listOf (t.either t.path t.str))
        ]);
        apply = let
          mapper = x:
            if builtins.typeOf x == "path"
            then pkgs.copyPathToStore x
            else x;

        in lib.mapAttrs (n: v:
          if lib.isList v
          then lib.concatStringsSep ":" (map mapper v)
          else mapper v
        );
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
