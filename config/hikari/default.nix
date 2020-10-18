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

  wallpaper = let
    file = pkgs.fetchurl {
      url = "https://cdnb.artstation.com/p/assets/images/images/002/223/417/large/minority-4-c.jpg";
      sha256 = "093bfinr7d2r9wr7vdfq9wjmkmzla5ycxr61gxw441l5kvbnppah";
    };
  in pkgs.runCommandNoCC "wallpaper-minority.png" {} ''
    ${pkgs.imagemagick}/bin/convert ${file} $out
  '';


in pkgs.hikari.customize {
  config = config // {
    outputs."*".background.fit = "center";
    outputs."*".background.path = wallpaper;

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
