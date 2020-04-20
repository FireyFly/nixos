{ pkgs, ... }:

let
  Keys = pkgs.callPackage ./keys.nix {};
  TermPanel = pkgs.callPackage ./term-panel.nix {};

  hc = "${pkgs.herbstluftwm}/bin/herbstclient";

  pangoterm = "${pkgs.pangoterm}/bin/pangoterm";
  xterm = "${pkgs.xterm}/bin/xterm";

in pkgs.writers.writeBash "autostart" ''
##-- Environment ----------------------------------------------------
hc() {
  herbstclient "$@"
}

${hc} emit_hook reload

# Update path to faciliate split-up config file.
#export PATH="$XDG_CONFIG_HOME/herbstluftwm:$XDG_CONFIG_PATH/herbstluftwm:$PATH"

# Useful configuration variables
export Mod=Mod4
export Term=pangoterm
#export Term=xterm

# Set background
export HC_BACKGROUND='#02080F'
xsetroot -solid '#02080F'
#xsetroot -solid "$HC_BACKGROUND"
#feh --bg-fill $HOME/local/share/wallpapers/current

# Setup tags
TagNames=( {1..9} )
TagKeys=( {1..9} )

${hc} rename default "''${TagNames[0]}" || true
for i in ''${!TagNames[@]} ; do
  ${hc} add "''${TagNames[$i]}"
done

##-- Keybindings ----------------------------------------------------
# remove all existing keybindings
${hc} keyunbind --all

# General window management
${hc} keybind $Mod-Shift-q quit
${hc} keybind $Mod-Shift-r reload
${hc} keybind $Mod-Shift-c close

${hc} keybind $Mod-Return spawn "${pangoterm}"
${hc} keybind $Mod-Shift-Return spawn "${xterm}"
#hc keybind $Mod-r spawn gmrun
#hc keybind $Mod-r emit_hook toggle_runner

# Setup tag bindings
#hc rename default "''${TagNames[0]}" || true
for i in ''${!TagNames[@]} ; do
# hc add "''${TagNames[$i]}"
  key="''${TagKeys[$i]}"
  if ! [ -z "$key" ] ; then
    ${hc} keybind "$Mod-$key" use_index "$i"
    ${hc} keybind "$Mod-Shift-$key" move_index "$i"
  fi
done

# Layouting
${hc} keybind $Mod-d remove
${hc} keybind $Mod-minus split vertical 0.5
${hc} keybind $Mod-v split horizontal 0.5

${hc} keybind $Mod-space       cycle_layout +1
${hc} keybind $Mod-Shift-space cycle_layout -1

${hc} keybind $Mod-m fullscreen toggle
${hc} keybind $Mod-f floating   toggle
${hc} keybind $Mod-p pseudotile toggle

# Resizing
ResizeStep=0.05
${hc} keybind $Mod-Control-h resize left  +$ResizeStep
${hc} keybind $Mod-Control-t resize down  +$ResizeStep
${hc} keybind $Mod-Control-n resize up    +$ResizeStep
${hc} keybind $Mod-Control-s resize right +$ResizeStep

# Mouse
${hc} mouseunbind --all
${hc} mousebind $Mod-Button1 move
${hc} mousebind $Mod-Button2 resize
${hc} mousebind $Mod-Button3 zoom

# Focus
${hc} keybind $Mod-BackSpace   cycle_monitor
${hc} keybind $Mod-Tab         use_previous
${hc} keybind $Mod-c cycle

${hc} keybind $Mod-h focus left
${hc} keybind $Mod-t focus down
${hc} keybind $Mod-n focus up
${hc} keybind $Mod-s focus right

# hc keybind $Mod-a jumpto urgent

# Move
${hc} keybind $Mod-Shift-h shift left
${hc} keybind $Mod-Shift-t shift down
${hc} keybind $Mod-Shift-n shift up
${hc} keybind $Mod-Shift-s shift right

# Layouts
${hc} keybind $Mod-Alt-1 load '
  (split horizontal:0.80:0
    (split horizontal:0.20:1
      (clients vertical:0)
      (clients grid:0))
    (clients vertical:0))
'

# External tools
${Keys}


##-- Rules ----------------------------------------------------------
${hc} unrule -F
${hc} rule focus=off # normally do not focus new clients
${hc} rule class~'(.*[Rr]xvt.*|.*[Tt]erm|Konsole)' focus=on
${hc} rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' tag=float
${hc} rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
${hc} rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK)' manage=off
${hc} rule class='PANEL' manage=off
#hc rule class='Gmrun' manage=off

# hc rule class=Gimp index=01 pseudotile=on
${hc} rule class=Gimp windowrole~'gimp-(image-window|toolbox|dock)' pseudotile=off
${hc} rule class=Gimp windowrole=gimp-toolbox-1 focus=off index=00 pseudotile=off
${hc} rule class=Gimp windowrole=gimp-dock-1 focus=off index=1 pseudotile=off

# Xonotic
#hc rule class=DarkPlaces focus=on fullscreen=off


##-- Options --------------------------------------------------------
# Original colours
#hc set frame_border_active_color  '#994422'
#hc set frame_border_normal_color  '#101010'
#hc set frame_bg_active_color      '#345F0C'
#hc set window_border_normal_color '#454545'
#hc set window_border_active_color '#9fbc00'
#hc set window_border_active_color '#00ff00'

# Kirby/pink
#hc set frame_border_active_color   '#FF7799'
# Orange
#hc set frame_border_active_color   '#FF4422'
# Bluish
${hc} set frame_border_active_color   '#336699'

# Generic to go with the above
${hc} set frame_border_normal_color   '#02080F'
${hc} set window_border_active_color  '#666666'
${hc} set window_border_normal_color  '#222222'
${hc} set frame_bg_active_color       '#080808'
${hc} set frame_bg_normal_color       '#111111'

#hc set frame_border_active_color   '#3366AA'
#hc set window_border_active_color  '#3366AA'
#hc set frame_bg_active_color       '#000000'
#hc set frame_border_normal_color   '#021433'
#hc set window_border_normal_color  '#222222'
#hc set frame_bg_normal_color       '#111111'

# CGA
#hc set frame_border_active_color   '#55FFFF'
#hc set frame_border_normal_color   '#FF55FF'
#hc set window_border_active_color  '#55FFFF'
#hc set window_border_normal_color  '#00AAAA'
#hc set frame_bg_active_color       '#FF55FF'
#hc set frame_bg_normal_color       '#AA00AA'

# Nice red
#hc set frame_border_active_color   '#F5F5C5'
#hc set frame_border_normal_color   '#E1485A'
#hc set window_border_active_color  '#FFFFFF'
#hc set window_border_normal_color  '#00AAAA'
#hc set frame_bg_active_color       '#FF55FF'
#hc set frame_bg_normal_color       '#AA00AA'

${hc} set focus_follows_mouse 1
${hc} set auto_detect_monitors 1
${hc} set frame_bg_transparent 1

#hc set frame_border_width 2
#hc set frame_border_inner_width 1
#hc set window_border_width 2
#hc set window_border_inner_width 1

${hc} set frame_border_width 4
${hc} set frame_border_inner_width 0
${hc} set frame_transparent_width 0
${hc} set window_border_width 1
${hc} set window_border_inner_width 0

${hc} set always_show_frame 0
${hc} set frame_gap 8
${hc} set window_gap 0
${hc} set frame_padding 1

${hc} set smart_window_surroundings 1
${hc} set smart_frame_surroundings 0

# unlock, just to be sure
${hc} unlock

${hc} set tree_style '⊙│ ├╰»─╮'

# do multi monitor setup here, e.g.:
# hc remove_monitor 1
# hc move_monitor 0 1280x1024+0+0
# hc add_monitor 1280x1024+1280+0

# auto-detect connected monitors
${hc} detect_monitors

#--- Panel ------------------
# TODO: make prettier--this is terribly hacky :|
#ps x | grep 'pangoterm --class=PANEL' | awk '{print $1}' | xargs kill
#panel_script="$HOME/.config/herbstluftwm/term-panel.sh"

panel_script=${TermPanel}

ps x | grep "bash $panel_script" | awk '{print $1}' | xargs kill
#pangoterm --class=PANEL --profile=panel --geometry=1366x10+0+0 "$panel_script"
pangoterm --class=PANEL --profile=panel --geometry=1920x10+0+0 "$panel_script"
#xterm -class PANEL -rv -geometry 226x1 -w 0 -e "bash $panel_script"
#xterm -class PANEL -rv -geometry 323x1 -w 0 -e "bash $panel_script"
''
