{ tzdata, mkShell, callPackage }:
  let
    profiles = callPackage ./profiles.nix {};
    shell-motd = callPackage ../shell-motd/default.nix {};
  in mkShell {
    packages = [ profiles ];

    shellHook = ''
      export TZDIR="${tzdata}/share/zoneinfo"

      if [ -z "$__SHELL_MOTD" ]; then
        export __SHELL_PROFILES="${profiles} $__SHELL_PROFILES \$__SHELL_MOTD"
      fi

      export __SHELL_MOTD="${shell-motd}"
    '';
  }
