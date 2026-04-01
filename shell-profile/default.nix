{ tzdata, git, mkShell, callPackage }:
  let
    profiles = callPackage ./profiles.nix {};
    shell-motd = callPackage ../shell-motd/default.nix {};
  in mkShell {
    packages = [ profiles ];

    shellHook = ''
      export TZDIR="${tzdata}/share/zoneinfo"
      export __SHELL_PROFILES="${profiles} ${git}/share/bash-completion/completions/ $__SHELL_PROFILES"

      if [ -z "$__SHELL_MOTD" ]; then
        export __SHELL_PROFILES="$__SHELL_PROFILES \$__SHELL_MOTD"
      fi

      export __SHELL_MOTD="${shell-motd}"
    '';
  }
