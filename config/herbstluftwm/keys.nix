{ pkgs, ... }:

pkgs.writers.writeBash "keys.sh" ''
#!/usr/bin/env bash
hc() {
  herbstclient "$@"
}

hc keybind XF86MonBrightnessDown spawn backlight.sh - 1
hc keybind XF86MonBrightnessUp   spawn backlight.sh + 1

hc keybind $Mod-F10              spawn scrotnow.sh
hc keybind XF86Display           detect_monitors

# Volume
hc keybind XF86AudioMute         spawn ponymix toggle
hc keybind XF86AudioLowerVolume  spawn ponymix decrease 2
hc keybind XF86AudioRaiseVolume  spawn ponymix increase 2

# XF86Display
# XF86Launch3

# Samsung
#hc keybind XF86Launch1 spawn \
#    samsung-tools --show-notify --quiet --backlight hotkey
#hc keybind XF86Launch2 spawn \
#    samsung-tools --show-notify --quiet --bluetooth hotkey

# Music
hc keybind $Mod-Alt-h spawn mpc toggle
hc keybind $Mod-Alt-t spawn mpc prev
hc keybind $Mod-Alt-n spawn mpc next

hc keybind $Mod-Alt-g spawn mpc-helper.sh grab
hc keybind $Mod-Alt-c spawn mpc-helper.sh copy
''
