{

  ui.border = 1;
  ui.gap = 5;
  ui.step = 100;
  ui.font = "DejaVu Sans Mono 10";
  ui.colorscheme = {
    background = 2632756; # 0x282C34;
    foreground = 0; # 0x000000;
    selected   = 16113712; # 0xF5E094;
    grouped    = 16625491; # 0xFDAF53;
    first      = 12117619; # 0xB8E673;
    conflict   = 15559474; # 0xED6B32;
    insert     = 14926742; # 0xE3C3FA;
    active     = 16777215; # 0xFFFFFF;
    inactive   = 4609111; # 0x465457;
  };

# inputs.pointers."ELAN0650:01 04F3:304B Touchpad" = {
  inputs.pointers."*" = {
    accel = 0.8;
    disable-while-typing = true;
    tap = true;
    tap-drag = true;
    tap-drag-lock = true;
    scroll-button = "middle";
    scroll-method = "on-button-down";
  };

  layouts.s = {
    # main stack
    scale = 0.75;
    left = "single";
    right = "stack";
  };
  layouts.q = {
    # main queue
    scale = 0.75;
    top = "single";
    bottom = "queue";
  };
  layouts.f = "full";
  layouts.h = "stack";
  layouts.v = "queue";
  layouts.g = "grid";

  bindings.keyboard = let
    vtBindings = {
      # Switch vt
      "CA+F1" = "vt-switch-to-1";
      "CA+F2" = "vt-switch-to-2";
      "CA+F3" = "vt-switch-to-3";
      "CA+F4" = "vt-switch-to-4";
      "CA+F5" = "vt-switch-to-5";
      "CA+F6" = "vt-switch-to-6";
      "CA+F7" = "vt-switch-to-7";
      "CA+F8" = "vt-switch-to-8";
      "CA+F9" = "vt-switch-to-9";

      # Switch vt - with Logo held (ideapad 520s bug workaround)
      "LCA+F1" = "vt-switch-to-1";
      "LCA+F2" = "vt-switch-to-2";
      "LCA+F3" = "vt-switch-to-3";
      "LCA+F4" = "vt-switch-to-4";
      "LCA+F5" = "vt-switch-to-5";
      "LCA+F6" = "vt-switch-to-6";
      "LCA+F7" = "vt-switch-to-7";
      "LCA+F8" = "vt-switch-to-8";
      "LCA+F9" = "vt-switch-to-9";
    };

    mediaBindings = {
      # XF86AUdioMute         -> spawn ponymix toggle
      # XF86AudioLowerVolume  -> spawn ponymix decrease 2
      # XF86AudioRaiseVolume  -> spawn ponymix increase 2
      "LA+h" = "action-music-toggle";
      "LA+t" = "action-music-prev";
      "LA+n" = "action-music-next";
      "LA+g" = "action-music-grab";
      "LA+c" = "action-music-copy";
    };

  in
  vtBindings // mediaBindings // {
    # General
    "LS+Backspace" = "lock";
    "LS+q"         = "quit";
    "LS+r"         = "reload";

    "L+Return"  = "action-terminal";

    # Sheets
    "L+0"      = "workspace-switch-to-sheet-0";
    "L+1"      = "workspace-switch-to-sheet-1";
    "L+2"      = "workspace-switch-to-sheet-2";
    "L+3"      = "workspace-switch-to-sheet-3";
    "L+4"      = "workspace-switch-to-sheet-4";
    "L+5"      = "workspace-switch-to-sheet-5";
    "L+6"      = "workspace-switch-to-sheet-6";
    "L+7"      = "workspace-switch-to-sheet-7";
    "L+8"      = "workspace-switch-to-sheet-8";
    "L+9"      = "workspace-switch-to-sheet-9";
    "L+Tab"    = "workspace-switch-to-sheet-alternate";
    "L+Comma"  = "workspace-switch-to-sheet-current";

    "LSC+g"      = "workspace-show-group";
    "LSC+i"      = "workspace-show-invisible";
    "LSC+Period" = "workspace-show-all";
    "LC+n"       = "workspace-cycle-next";
    "LC+p"       = "workspace-cycle-prev";

    "LC+i"     = "sheet-show-invisible";
    "LC+Comma" = "sheet-show-all";

    "LS+0"     = "view-pin-to-sheet-0";
    "LS+1"     = "view-pin-to-sheet-1";
    "LS+2"     = "view-pin-to-sheet-2";
    "LS+3"     = "view-pin-to-sheet-3";
    "LS+4"     = "view-pin-to-sheet-4";
    "LS+5"     = "view-pin-to-sheet-5";
    "LS+6"     = "view-pin-to-sheet-6";
    "LS+7"     = "view-pin-to-sheet-7";
    "LS+8"     = "view-pin-to-sheet-8";
    "LS+9"     = "view-pin-to-sheet-9";
    "LS+Tab"   = "view-pin-to-sheet-alternate";
    "LS+Comma" = "view-pin-to-sheet-current";

    # View movement & resize
    "L+Up"      = "view-move-up";
    "L+Down"    = "view-move-down";
    "L+Left"    = "view-move-left";
    "L+Right"   = "view-move-right";
    "LS+Up"     = "view-decrease-size-up";
    "LS+Down"   = "view-increase-size-down";
    "LS+Left"   = "view-decrease-size-left";
    "LS+Right"  = "view-increase-size-right";
    "LC+Up"     = "view-snap-up";
    "LC+Down"   = "view-snap-down";
    "LC+Left"   = "view-snap-left";
    "LC+Right"  = "view-snap-right";
    "L+r"       = "view-reset-geometry";

    "L+k"       = "view-cycle-prev";
    "L+j"       = "view-cycle-next";
    "LS+k"      = "view-lower";
    "LS+j"      = "view-raise";

    "L+m"       = "view-toggle-maximize-full";
    "LS+m"      = "view-toggle-maximize-vertical";
    "L+f"       = "view-toggle-floating";
    "L+i"       = "view-toggle-invisible";

    "LS+c"      = "view-quit";

    # Group focus
  # "LS+o"     = group-only
  # "LS+h"     = group-hide
  # "L+k"      = group-raise
  # "L+j"      = group-lower
  # "L+h"      = group-cycle-prev
  # "L+s"      = group-cycle-next
  # "L+t"      = group-cycle-view-prev
  # "L+n"      = group-cycle-view-next
    "LS+Home"  = "group-cycle-view-first";
    "LS+End"   = "group-cycle-view-last";

    # Layout focus & movement
  # "L+h"      = layout-cycle-view-first
    "L+t"      = "layout-cycle-view-prev";
    "L+n"      = "layout-cycle-view-next";
  # "LS+h"     = layout-exchange-view-main
    "LS+t"     = "layout-exchange-view-prev";
    "LS+n"     = "layout-exchange-view-next";

    # Mode changes
    "L+l"       = "mode-enter-layout";
    "L+g"       = "mode-enter-group-assign";
  # "L+s"       = mode-enter-sheet-assign
  # "L+m"       = mode-enter-mark-assign
  # "L+acute"   = mode-enter-mark-select
  # "LS+acute"  = mode-enter-mark-switch-select
    "LCA+g"     = "mode-enter-input-grab";
    "LS+escape" = "mode-enter-input-grab";
  };

  bindings.mouse = {
    "L+left"  = "mode-enter-move";
    "L+right" = "mode-enter-resize";
  };

}
