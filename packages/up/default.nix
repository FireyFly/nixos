{ stdenv, coreutils, exiftool, rsync, xclip }:

let
  lib = import ../../lib;

in lib.mkScriptDerivation {
  name = "up";
  src = ./up.in;

  host = "hagall";
  hostLocation = "/var/www/up.firefly.nu";
  clipboardPrefix = "https://up.firefly.nu/";

  basename = "${coreutils}/bin/basename";
  exiftool = "${exiftool}/bin/exiftool";
  rsync = "${rsync}/bin/rsync";
  xclip = "${xclip}/bin/xclip";
}
