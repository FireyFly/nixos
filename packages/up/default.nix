{ writeShellScriptBin, coreutils, openssh, exiftool, xclip }:

writeShellScriptBin "up"
''
  if [ $# -lt 1 ]; then
    echo >&2 "Usage: $0 <filename>"
    exit 1
  fi

  dir="$(${coreutils}/bin/basename "$0")"  # target directory to upload to--'up' or 'pub'

  for f in "$@"; do
    target="$(${coreutils}/bin/basename "$f")"

    # Preprocessing
    case "$f" in
      *.jpg)  # Strip GPS metadata
        cp "$f" /tmp/"$target"
        f=/tmp/"$target"
        ${exiftool}/bin/exiftool -q -gps:all= -xmp:all= "$f"
        ;;
    esac

    # Upload
    path="$dir/$target"
    ${openssh}/bin/scp -r "$f" fe:srv/http/"$path"
  done

  ${xclip}/bin/xclip -i <<<"http://xen.firefly.nu/$path"
  ${xclip}/bin/xclip -selection clipboard -i <<<"http://xen.firefly.nu/$path"
''
