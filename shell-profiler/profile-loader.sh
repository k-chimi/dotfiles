case $- in
  *i*) ;;
  *) return $1 ;;
esac

[ ! -z "$__SHELL_PROFILES_LOADED" ] && return $1

__SHELL_PROFILES_LOADED=1
  
for profile in $__SHELL_PROFILES; do
  if [ -d "$profile" ]; then
    for item in "$profile"/*; do
      . "$item"
    done
  elif [ -f "$profile" ]; then
    . "$profile"
  fi
done

return $1
