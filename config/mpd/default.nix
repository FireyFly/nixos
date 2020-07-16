{ pkgs, ... }:

pkgs.mpd.customize {
  config.music_directory = "~/media/music";
  config.db_file = "~/local/var/mpd/database";
  config.log_file = "~/local/var/log/mpd.log";
  config.pid_file = "~/local/var/mpd/pid";
  config.state_file = "~/local/var/mpd/state";
  config.sticker_file = "~/local/var/mpd/sticker.db";

  config.bind_to_address = "127.0.0.1";
  config.restore_paused = true;
}
