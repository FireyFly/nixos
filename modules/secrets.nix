{ lib, ... }:

let
  inherit (lib) types;

  nestedAttrsOf = x:
    types.attrsOf (types.either x (nestedAttrsOf x));

in {
  options = {
    mine.secrets = lib.mkOption {
      type = nestedAttrsOf types.str;
      default = {};
      description = "Secrets, as arbitrarily nested strings";
    };
  };

  config = {
    mine.secrets = import ../secrets/secrets.nix;
  };
}
