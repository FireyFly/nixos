{ stdenv, ripgrep, zsh, ucd }:

let
  lib = import ../../lib;

in lib.mkScriptDerivation {
  name = "charselect";
  src = ./charselect.in;

  inherit ucd;
  shell = "${zsh}/bin/zsh";
  grep = "${ripgrep}/bin/rg";
}
