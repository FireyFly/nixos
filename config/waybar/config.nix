{
  layer = "top";
  position = "top";
  height = 20;
  width = 1920;

  modules-right = [
    "mpd"
    "idle_inhibitor"
    "pulseaudio"
    "network"
    "cpu"
    "memory"
    "temperature"
    "backlight"
    "battery"
    "clock"
  ];

  # Modules configuration
  mpd = {
    format = "{stateIcon} {title}";
    format-disconnected = "Disconnected";
    format-stopped = "Stopped";
    unknown-tag = "N/A";
    interval = 2;
    consume-icons = {
      on = " ";
    };
    random-icons = {
      off = "<span color=\"#f53c3c\"></span> ";
      on = " ";
    };
    repeat-icons = {
      on = " ";
    };
    single-icons = {
      on = "1 ";
    };
    state-icons = {
      paused = "";
      playing = "";
    };
    tooltip-format = "MPD (connected)";
    tooltip-format-disconnected = "MPD (disconnected)";
  };
  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = "";
      deactivated = "";
    };
  };
  tray = {
    spacing = 10;
  };
  clock = {
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format-alt = "{:%Y-%m-%d}";
  };
  cpu = {
    format = "{usage}% ";
    tooltip = false;
  };
  memory = {
    format = "{}% ";
  };
  temperature = {
    critical-threshold = 80;
    format = "{temperatureC}°C {icon}";
    format-icons = ["" "" ""];
  };
  backlight = {
    format = "{percent}% {icon}";
    format-icons = ["" ""];
  };
  battery = {
    states = {
      # "good": 95;
      warning = 50;
      critical = 20;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% ";
    format-plugged = "{capacity}% ";
    format-alt = "{time} {icon}";
    # "format-good": "", // An empty format will hide the module
    # "format-full": "";
    format-icons = ["" "" "" "" ""];
  };
  "battery#bat2" = {
    bat = "BAT2";
  };
  network = {
    # "interface": "wlp2*", // (Optional) To force the use of this interface
    format-wifi = "{essid} ({signalStrength}%) ";
    format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
    format-linked = "{ifname} (No IP) ";
    format-disconnected = "Disconnected ⚠";
    format-alt = "{ifname}: {ipaddr}/{cidr}";
  };
  pulseaudio = {
    format = "{volume}% {icon} {format_source}";
    format-bluetooth = "{volume}% {icon} {format_source}";
    format-bluetooth-muted = " {icon} {format_source}";
    format-muted = " {format_source}";
    format-source = "{volume}% ";
    format-source-muted = "";
    format-icons = {
      headphone = "";
      hands-free = "";
      headset = "";
      phone = "";
      portable = "";
      car = "";
      default = ["" "" ""];
    };
    on-click = "pavucontrol";
  };
}
