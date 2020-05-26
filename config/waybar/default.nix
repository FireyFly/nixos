{ pkgs, ... }:

pkgs.configurable.waybar {
  config = import ./config.nix;
  stylesheetFile = ./style.css;
}
