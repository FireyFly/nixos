
self: super: {
  # assume there's no 'configurable' in nixpkgs top-level
  configurable = {

    hikari = opts: super.callPackage ./hikari.nix opts;

  };
}

