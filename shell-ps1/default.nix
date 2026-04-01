{ runCommand, mkShell, which, callPackage }:
  let
    ansi-colors = import ../lib/ansi-colors.nix { mode = "sh"; };
    prompt-command = callPackage ./package.nix {};
    fg = ansi-colors.fg;
    bg = ansi-colors.bg;
  in
    mkShell {
      name = "kchimi-shell-ps1";

      packages = [ which prompt-command ];
    
      shellHook = ''
        export PROMPT_FMT=''\'''${PROMPT_STATUS@P}''\'"${ansi-colors.bold}${fg.light_green}\u@\H${ansi-colors.reset} ${ansi-colors.bold}"''\'''${PROMPT_CWD@P}''\'"${ansi-colors.reset}"''\'''${PROMPT_BRANCH@P}''${PROMPT_BRANCH_CHANGES@P}''${PROMPT_NIX_SHELL@P}\n''\'"\$ "
        export PS1="$PROMPT_FMT"

        export PROMPT_COMMAND="''${PROMPT_COMMAND/%/;}. ${prompt-command}/__prompt_command \$?"
        export PROMPT_COMMAND_ADDITIONAL="prompt_cwd prompt_nix prompt_git"

        export PROMPT_STATUS=""
        export PROMPT_STATUS_FMT='${fg.ansi256 "197"}%03d${fg.reset} '

        export PROMPT_BRANCH=""
        export PROMPT_BRANCH_FMT=' ${fg.ansi256 "215"}#%s${ansi-colors.reset}'
        
        export PROMPT_BRANCH_CHANGES=""
        export PROMPT_BRANCH_CHANGES_FMT='${fg.light_black}%s${fg.reset}'

        export PROMPT_CWD=""

        export PROMPT_GIT=""
        export PROMPT_GIT_TIME="0"
        export PROMPT_GIT_PREVPATH="$PWD"
        export PROMPT_BRANCH_NAME=""

        export PROMPT_NIX_SHELL=""
        export PROMPT_NIX_SHELL_FMT=' ${fg.ansi256 "153"}(%s)${ansi-colors.reset} '
      '';
    }
