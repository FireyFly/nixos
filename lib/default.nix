let
  nixpkgs = import <nixpkgs> {};
  inherit (nixpkgs) stdenv;

in {

  mkScriptDerivation = args:
    let
      inherit (args) name;
      input = "${name}.in";
    in
      stdenv.mkDerivation (args // {
        unpackPhase = ''
          cp $src ${input}
        '';

        configurePhase = ''
          substituteAll ${input} ${name}
          chmod +x ${name}
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp ${name} $out/bin
        '';
      });

}
