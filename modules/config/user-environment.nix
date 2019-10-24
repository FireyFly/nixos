{ config, lib, utils, pkgs, ... }:

with lib;

let
  cfg = config.mine.users;

  # adapted from nixos shells-environment.nix
  exportStringOf = vars:
    let
      exportStringOfOne = n: v: ''export ${n}="${concatStringsSep ":" v}"'';
      exportVariables = mapAttrsToList exportStringOfOne (mapAttrs (n: toList) vars);
    in
      concatStringsSep "\n" exportVariables;

  userOpts = {
    options = {

      environment = mkOption {
        # adapted from nixos shells-environment.nix
        default = {};
        type = with types; attrsOf (either str (listOf str));
        apply = mapAttrs (n: v: if isList v then concatStringsSep ":" v else v);
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

    mine.users.users = mkOption {
      default = {};
      type = with types; loaOf (submodule userOpts);
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

  config = {
    environment.etc =
      # adapted from nixos users-groups.nix
      (mapAttrs' (name: { environment, ... }: {
        name = "environments/per-user/${name}";
        value.text = ''
        # DO NOT EDIT -- this file has been generated automatically.

        ${exportStringOf environment}
        '';
      }) (filterAttrs (_: u: u.environment != {}) cfg.users));

    environment.extraInit = ''
    # setup user-specific environment variables
    if [ -x "/etc/environments/per-user/$USER" ]; then
      . "/etc/environments/per-user/$USER"
    fi
    '';
  };

}
