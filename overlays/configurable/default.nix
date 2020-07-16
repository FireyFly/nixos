
let
  makeCustomizeWrapper = pkgs: wrapperDerivation:
    let
      # add '.customize' function to package, modelled somewhat after nixpkgs
      # vim-plugins/vim-utils.nix
      makeCustomizable = package: package // {
        customize = opts:
          pkgs.callPackage wrapperDerivation (opts // { inherit package; });

        override = f: makeCustomizable (package.override f);
        overrideAttrs = f: makeCustomizable (package.overrideAttrs f);
      };
    in makeCustomizable;
in

self: super: let
  makeCustomizeWrapper' = makeCustomizeWrapper super;
in {
  alacritty = makeCustomizeWrapper' ./alacritty.nix super.alacritty;
  hikari = makeCustomizeWrapper' ./hikari.nix super.hikari;
  mpd = makeCustomizeWrapper' ./mpd.nix super.mpd;
  waybar = makeCustomizeWrapper' ./waybar.nix super.waybar;
}

