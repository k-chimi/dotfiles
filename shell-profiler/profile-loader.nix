{ stdenv }:
  stdenv.mkDerivation {
    name = "shell-profile-loader";

    src = ./.;

    buildPhase = ''
      mkdir -p $out
      cp $src/profile-loader.sh $out/__load_profile
      chmod +x $out/__load_profile
    '';
  }
