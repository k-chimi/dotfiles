{ mkShell, callPackage }:
  let
    profiles = callPackage ./profiles.nix {};
  in mkShell {
    packages = [ profiles ];

    shellHook = ''
      export __SHELL_PROFILES="${profiles} $__SHELL_PROFILES"
    '';
  }
