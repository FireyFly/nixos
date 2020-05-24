{ pkgs, ... }:

let
  config = import ./config.nix;

in {
  programs.hikari.settings = config // {
    outputs."*".background = "${pkgs.hikari}/share/backgrounds/hikari/hikari_wallpaper.png";

    actions.terminal = "${pkgs.alacritty}/bin/alacritty";

    # mpc control
    actions.music-toggle = "${pkgs.mpc_cli}/bin/mpc toggle";
    actions.music-prev = "${pkgs.mpc_cli}/bin/mpc prev";
    actions.music-next = "${pkgs.mpc_cli}/bin/mpc next";
    actions.music-grab = "${pkgs.mpc-helper}/bin/mpc-helper grab";
    actions.music-copy = "${pkgs.mpc-helper}/bin/mpc-helper copy";
  };

  programs.hikari.autostartLines = ''
    ${pkgs.waybar}/bin/waybar
  '';
}
