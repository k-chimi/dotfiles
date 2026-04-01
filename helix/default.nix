{ runCommand, helix, callPackage }:
  let
    inherit (callPackage ./customizer.nix {}) MkHelixRuntime MkCustomizedHelix MkConfig MkLanguage;
    runtime = MkHelixRuntime {
      runtimes = [
        (MkConfig {
          config = builtins.fromTOML (builtins.readFile ./config.toml);
        })
      ];
    };
  in
    MkCustomizedHelix {
      name = "kchimi-helix";
      inherit runtime;
    }
