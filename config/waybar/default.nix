{ lib, pkgs, ... }:

let
  config = import ./config.nix;

in {
  environment.etc."xdg/waybar/config".text = lib.generators.toJSON {} config;
  environment.etc."xdg/waybar/style.css".source = ./style.css;
}
