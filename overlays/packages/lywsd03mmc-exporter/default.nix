{ buildGoPackage, fetchFromGitHub }:

let
  owner = "leahneukirchen";
  repo = "lywsd03mmc-exporter";

in buildGoPackage {
  pname = repo;
  version = "dev";
  goPackagePath = "github.com/${owner}/${repo}";
  src = fetchFromGitHub {
    inherit owner repo;
    rev = "c9d10cb0946ee6b8695bf0139f94afae5dab238d";
    sha256 = "18n3am4i2ii82f52kwm8c4sy72pa8jlx8biv4znml0xgsyp2gqx9";
  };
  goDeps = ./deps.nix;
}
