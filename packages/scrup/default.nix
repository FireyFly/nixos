{ writeShellScriptBin, coreutils, scrot, up }:

writeShellScriptBin "scrup"
''
  dir=/tmp/scrot
  mkdir -p "$dir"
  ${scrot}/bin/scrot "$@" "$dir/%Y-%m-%d_%H%M%S.png" -e '${up}/bin/up $f'
''

