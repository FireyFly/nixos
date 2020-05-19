{ stdenv, ripgrep, zsh, unicode-character-database }:

let
  lib = import ../../lib;

in lib.mkScriptDerivation {
  name = "charselect";
  src = ./charselect.in;

  ucd = "${unicode-character-database}/share/unicode";
  shell = "${zsh}/bin/zsh";
  grep = "${ripgrep}/bin/rg";
}
