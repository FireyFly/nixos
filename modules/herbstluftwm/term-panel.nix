{ pkgs, ... }:

let
  plaintext = "${pkgs.plaintext}/bin/plaintext";
  helper = pkgs.callPackage ./helper.nix {};

in pkgs.writers.writeBash "term-panel.sh" ''
herbstclient pad 0 15

panel_dir="$(dirname "$0")"
util_dir="$panel_dir/util"

sys_backlight=/sys/class/backlight/intel_backlight/

function uniq_linebuffered() {
  awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

widget_network() {
  ssid=$(iw dev | grep ssid | sed -r 's/^\s*ssid //')
  [ -z "$ssid" ] && ssid="$Default"
  printf '%s (%s)' "$ssid" "$AMBIENT_ICOMERA_PROVIDER"
}

# disable cursor
echo -ne "\e[?25l"

# SGR vars
Esc="$(echo -e '\e')"
b="$Esc[1m" rb="$Esc[22m"
i="$Esc[3m" ri="$Esc[23m"
u="$Esc[4m" ru="$Esc[24m"
n="$Esc[7m" rn="$Esc[27m"
r="$Esc[m"
#fg="$Esc[31m"
#sg="$Esc[38:5:244m"
#col_curr='38:5:174'

#fg="$Esc[31m"
#sg="$Esc[38:5:244m"
#fg="$Esc[38:2:255;85;255m"
#sg="$Esc[38:2:85:255:255m"
#col_curr='38:2:255:85:255'

#fg="$Esc[38:2:255;119;153m"
#sg="$Esc[38:2:150:150:150m"
#col_curr='38:2:255:119:153'

# Orange
#col_curr='38:2:255:68:34'
# Bluish
col_curr='38:2:68:119:170'

fg="$Esc[''${col_curr}m"
sg="$Esc[38:2:150:150:150m"

cols=$(TERM=xterm tput cols)

{
  #--- Emit events --------------------
  which mpc >/dev/null && mpc idleloop player &

  while true; do echo tick; sleep 20; done &
  while true; do echo occasionally; sleep 200; done &

  while true; do
    date +"date"$'\t'"%H:%M$sg %a %Y-%m-%d$r"
    sleep 1 || break
  done > >(uniq_linebuffered) &

  echo brightness
  inotifywait -q -m $sys_backlight/uevent -e CLOSE --format brightness &

  herbstclient --idle

} 2>/dev/null | {
  # Default values for the panel-drawing part
  TAGS=( $(herbstclient tag_status 0) x )
# visible=true

  windowtitle=""

  Default="--"
  sep=""

  # fields of the right panel
  date="$Default"
  brightstatus="$Default"
  batstatus="$Default"
  thermstatus="$Default"
# nowplayingsym="♫"
# nowplaying="$Default"
  network="$Default"
  pacstatus="$Default"

  while true; do
    #--- Draw panel -------------------
    L=" "

    # Tags
    next=""
    for i in "''${TAGS[@]}"; do
     forced_sym=""
     [ x$next != x ] && forced_sym="$next"
   # skip="" next="" sym="⮁"
     skip="" next="" sym=" "
     case ''${i:0:1} in
       '.')  skip=1                                                           ;;
       ':')  color="38:5:240" sym="$Esc[38:5:240m$sym"                        ;;
     # '#')  color="1"        sym="$Esc[7;38:5:31m⮀"  next="$Esc[38:5:31m⮀" ;;
     # '#')  color="1"        sym="$Esc[7;38:5:31m▌"  next="$Esc[38:5:31m▌" ;;
   #   '#')  color="1"        sym="$Esc[7;38:5:174m▌"  next="$Esc[38:5:174m▌" ;;
       '#')  color="1"        sym="$Esc[7;''${col_curr}m▌" next="$Esc[''${col_curr}m▌" ;;
       '!')  color=""         sym="$Esc[31m$sym"                              ;;
       'x')                   sym="$Esc[38:5:240m$sym"                        ;;
        * )  color=""         sym="$Esc[30m$sym"                              ;;
     esac
     [ x"$forced_sym" != x ] && sym="$forced_sym"
     if [ x"$skip" == x ]; then
       L="$L$sym $Esc[''${color}m''${i:1} $r"
     else
       next="$forced_sym"  # save again
     fi
    done
    L="$L$r"

    # Then, the right panel
#   R=""
#   R="$R $fg ♫ $r$nowplaying"   # ♫
#   R="$R $fg ⚡ $r$batstatus"    # ⚡
#   R="$R $fg ☀ $r$brightstatus" # ☀
#   R="$R $fg ⽕ $r$thermstatus" # ♨☕
# # R="$R $fg ⌬ $r$wicdstatus"   # ⌬🌐
#   R="$R $fg ᗧ $r$pacstatus"    # ᗧ
#   R="$R $fg ⌚ $r$date"         # ⌚

    R=""
#   R="$R $fg 🔊 $r$nowplaying"   # ♫ 🔊
    R="$R $fg $nowplayingsym $r$nowplaying"   # ♫ 🔊
    R="$R $batstatus"    # ⚡
    R="$R $fg  ☀ $r$brightstatus" # ☀
    R="$R $fg 🌡 $r$thermstatus"  # 🔥♨☕
    R="$R $fg  ⌬ $r$network"
  # R="$R $fg 📦 $r$pacstatus"    # ᗧ
    R="$R $fg ⏲ $r$date"         # ⌚

  # Brightness    🔅  🔆  💡             |
  # Volume/Music  🔇  🔈  🔉  🔊          |
  # Power         🔋  🔌  🗲             |
  # Search?       🔍                   |
  # E-mail        📧  📨  📩  🖂  🖄       |
  # Mounts?       💾  💿  📁  📂  🗀  🗁  🖿 |
  # Packages      📦                   |
  # Temperature   🔥  ㊋

  # Music       ♫
  # Brightness  ☀
  # Network     ⌬

  # # Title
    L_len=$(${helper} display-width "$(${plaintext} <<<"$L")")
    R_len=$(${helper} display-width "$(${plaintext} <<<"$R")")

    # Title
    space_left=$((cols - (L_len + 2) - (R_len + 2) - 3))
    wt="$($util_dir/helper trim-title "$windowtitle" $space_left)"
    wt_len=$($util_dir/helper display-width "$wt")

    L="$L  $wt"
    padding=$((cols - (L_len + 2) - (R_len + 2) - wt_len - 3))

  # printf "\r%s%$((space_left - ''${#wt} - 2))s%s\e[K" "$L" "" "$R"
    printf "\r$r%s%''${padding}s%s\e[K" "$L" "" "$R"


    #--- Read event -------------------
    IFS=$'\t' read -ra cmd || break

    case "''${cmd[0]}" in
      tag*)
        TAGS=( $(herbstclient tag_status 0) x )
        ;;

      quit_panel|reload)
        echo "\rexiting..."
        exit
        ;;

      focus_changed|window_title_changed)
        windowtitle="''${cmd[@]:2}"
        ;;

      date)
        date="''${cmd[@]:1}"
        ;;

      brightness)
        brightstatus="$( curr=$(cat $sys_backlight/brightness)
                         max=$(cat $sys_backlight/max_brightness)
                         (( percent=100 * $curr / $max ))
                         printf "%d$sg%%$r" $percent )"
        ;;

      tick)
        batstatus="$( t='/sys/class/power_supply/BAT?/'
                      status=$(cat $t/status)
                      percent=$(cat $t/capacity)
                      color=$( ([ "$percent" -le 10 ] && echo -e '\e[48:5:160m\e[1m') ||
                               ([ "$percent" -le 25 ] && echo -e '\e[33;1m') ||
                               (true                  && echo -e "") )

                      case "$status" in
                    #   Full|Unknown)  printf "$sg%s$r" "$status" ;;
                    #   *)  printf "$sg%s: $r$color%d$sg%%$r$sg$r" "$status" $percent ;;
                        Charging|Full|Unknown) printf "$fg$color  🗲 $r%d$sg%%$r" $percent ;;
                        Discharging)           printf "$fg$color  🗲 $r%d$sg%%$r" $percent ;;
                      esac )"

        thermstatus="$( t='/sys/class/thermal/thermal_zone0'
                        curr=$(cat $t/temp)
                        degrees=$(printf '%d / 1000\n' $curr | bc)
                        printf "%d$sg°C$r" $degrees )"

      # network="--"
        network="$(fish "$HOME/repos/others/ambient/ambient" "$util_dir/widget_network")"
        ;;

    # occasionally)
    #   pacstatus="$(checkupdates | wc -l)"
    #   ;;

      mpd_player|player)
        status="$(mpc status | head -n 2 | tail -n 1 | grep -o '[a-z]\+' | head -n 1)"
        case "$status" in
          playing) nowplayingsym="⯈" ;;
          paused)  nowplayingsym="⏸" ;;
          stopped) nowplayingsym="⯀" ;;
          *)       nowplayingsym="♫" ;;
        esac
        nowplaying="$(mpc current -f "[%artist% - ][%title%|%file%]")"
        ;;
    esac
  done
}
''
