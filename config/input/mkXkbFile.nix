{ lib, runCommandNoCC, xorg }:

let
  makeIncludes = arr: lib.concatMapStringsSep "\n" (s: ''include "${s}"'') arr;

in

{ name
, directories ? [ "${xorg.xkeyboardconfig}/share/X11/xkb" ]
, keycodes ? [ "evdev" "aliases(qwerty)" ]
, types ? [ "complete" ]
, compats ? [ "complete" ]
, symbols ? [ "pc" "se(dvorak)" "inet(evdev)" ]
, geometries ? [ "pc(pc104)" ]
}:
  runCommandNoCC name {
    directories = map (dir: "-I${dir}") directories;
  } ''
    ${xorg.xkbcomp}/bin/xkbcomp -xkb -I $directories - $out <<END
      xkb_keymap {
        xkb_keycodes "generated" {
          ${makeIncludes keycodes}
        };
        xkb_types "generated" {
          ${makeIncludes types}
        };
        xkb_compatibility "generated" {
          ${makeIncludes compats}
        };
        xkb_symbols "generated" {
          ${makeIncludes symbols}
        };
        xkb_geometry "generated" {
          ${makeIncludes geometries}
        };
      };
    END
  ''
