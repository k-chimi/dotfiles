{ stdenv }:
  stdenv.mkDerivation {
    name = "kchimi-shell-profiles";

    src = ./.;

    buildPhase = ''
      mkdir -p $out

      cp $src/*.sh $out
    '';
  }
