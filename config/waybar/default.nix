{ pkgs, ... }:

pkgs.waybar.customize {
  config = import ./config.nix;
  stylesheetFile = ./style.css;
}
