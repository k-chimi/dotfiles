{ tzdata, mkShell, callPackage }:
  let
    profiles = callPackage ./profiles.nix {};
    shell-motd = callPackage ../shell-motd/default.nix {};
  in mkShell {
    packages = [ profiles ];

    shellHook = ''
      export TZDIR="${tzdata}/share/zoneinfo"
      export __SHELL_PROFILES="${profiles} $__SHELL_PROFILES ${shell-motd}"
    '';
  }
