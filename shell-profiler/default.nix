{ runCommand, mkShell, callPackage }:
  let
    profile-loader = callPackage ./profile-loader.nix { };
  in
    mkShell {
      packages = [ profile-loader ];
      
      shellHook = ''
        export PROMPT_COMMAND=". ${profile-loader}/__load_profile \$?; $PROMPT_COMMAND"
      '';
    }
