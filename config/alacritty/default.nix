{ pkgs, ... }:

pkgs.alacritty.customize {
  config = {
    window.padding = { x = 2; y = 2; };
    window.decorations = "none";

    font.size = 10;
    draw_bold_text_with_bright_colors = true;
  };
}
