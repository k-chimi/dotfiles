{ stdenv, callPackage }:
  let cacert-profile = callPackage ./cacert.nix { };
  in stdenv.mkDerivation {
    name = "kchimi-shell-profiles";

    src = ./.;

    buildPhase = ''
      mkdir -p $out

      cp $src/*.sh $out
      cp "${cacert-profile}" $out/cacert-profile.sh
    '';
  }
