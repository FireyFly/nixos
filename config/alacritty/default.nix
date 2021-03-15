{ pkgs, ... }:

pkgs.alacritty.customize {
  config = {
    env.TERM = "xterm-256color";

    window.padding = { x = 2; y = 2; };
    window.decorations = "none";

    font.size = 9;
    draw_bold_text_with_bright_colors = true;

    cursor.style.blinking = "never";

    colors.primary.background = "#000000";
  };
}
