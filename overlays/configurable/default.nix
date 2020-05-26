
self: super: {
  # assume there's no 'configurable' in nixpkgs top-level
  configurable = {

    alacritty = opts: super.callPackage ./alacritty.nix opts;
    hikari = opts: super.callPackage ./hikari.nix opts;
    waybar = opts: super.callPackage ./waybar.nix opts;

  };
}

