{ writeText }:
  let
    ansi-colors = import ../lib/ansi-colors.nix { mode = "sh"; };
    fg = ansi-colors.fg;
    bg = ansi-colors.bg;
  in  
    writeText "shell-motd.sh" ''
      [ -z "$__SHELL_MOTD" ] && return
      unset __SHELL_MOTD
      
      {
        print-title() {
          echo -e "$1$2"
        }
        
        print-entry() {
          echo -e "$1$(printf ''\'%s: ${fg.ansi256 "223"}%s${fg.reset}''\' "$2" "$3")"
        }
        
        print-entry-block() {
          echo -e "$1$2:"

          (
            i=0
            more_count=0
            IFS=$' '

            echo -n "$3"

            it=($4)
            for x in ''${it[@]}; do
              if [ "$i" -lt 15 ]; then
                if [[ "$x" =~ $'\n' ]]; then
                  sep=$'\n'"$3"
                elif [ "$i" -eq 0 ]; then
                  sep=
                else
                  sep=" "
                fi
                
                echo -n "$sep$(printf ''\'${fg.ansi256 "223"}%s${fg.reset}''\' "''${x#$'\n'}")"
                (( i ++ ))
              else
                more_count="$(( "''${#it[@]}" - "$i" ))"
                break
              fi
            done

            [ "$sep" == " " ] && echo

            if [ "$more_count" -gt 0 ]; then
              echo "$3$(printf ''\'${fg.ansi256 "245"}( more %s )${fg.reset}''\' "$more_count")"
            fi
          )
        }

        get-raw-nix-packages() {
          echo $PATH \
            | tr ':' '\n' \
            | grep -Eo "$NIX_STORE/[a-z0-9]+(-[^-/]+)+" \
            | sed -nE 's/\/([^/]+\/)+[a-z0-9]+-([^-/]+(-[^-/0-9]+)*).*$/\2/gp'
        }

        get-nix-packages() {
          (
            IFS=$'\n'
            local -A entries=()

            for x in $(get-raw-nix-packages); do
              if [ -z "''${entries[$x]}" ]; then
                echo $x
                entries[$x]=1
              fi
            done
          )
        }

        print-nix-packages() {
          (
            IFS=$'\n'
            i=1

            for x in $(get-nix-packages); do
              echo -n "$x"
            
              if [ ! "$i" -lt 5 ]; then
                echo -n $' \n'
                i=1
              else
                echo -n ' '
                (( i ++ ))
              fi
            done
          )
        }
      
        main() {
          local PAD="  "

          echo
          print-title "$PAD" '${ansi-colors.bold}${fg.ansi256 "111"}Nix${ansi-colors.reset}'
          print-entry "$PAD$PAD" "Name" "$name"
          print-entry "$PAD$PAD" "System" "$system"
          print-entry "$PAD$PAD" "IN_NIX_SHLL" "$IN_NIX_SHELL"
          print-entry-block "$PAD$PAD" "Packages" "$PAD$PAD$PAD" "$(print-nix-packages)"
          echo
        }

        main $@
      }
    ''
