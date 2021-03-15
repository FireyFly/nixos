{ pkgs, ... }:

let
  config = import ./config.nix;

  alacritty = import ../alacritty { inherit pkgs; };
  waybar = import ../waybar { inherit pkgs; };

  mpc-helper = pkgs.writeShellScript "mpc-helper" ''
    fmt='[%artist% - ][%title%|%file%]'
    case "$1" in
      grab) ${pkgs.mpc_cli}/bin/mpc -f "$fmt" current >>$HOME/media/music/grabs ;;
      copy) ${pkgs.mpc_cli}/bin/mpc -f "$fmt" current | ${pkgs.wl-clipboard}/bin/wl-copy ;;
      *) echo >&2 "$0: unknown command '$1'"; exit 1 ;;
    esac
  '';

in pkgs.hikari.customize {
  config = config // {
    outputs."*".background.fit = "center";
    outputs."*".background.path = ./miv4t-minority.png;

    actions.terminal = "${alacritty}/bin/alacritty";

    # mpc control
    actions.music-toggle = "${pkgs.mpc_cli}/bin/mpc toggle";
    actions.music-prev = "${pkgs.mpc_cli}/bin/mpc prev";
    actions.music-next = "${pkgs.mpc_cli}/bin/mpc next";
    actions.music-grab = "${mpc-helper} grab";
    actions.music-copy = "${mpc-helper} copy";
  };

  autostartLines = ''
    ${waybar}/bin/waybar
  '';
}
