_:prompt_set_branch() {
  PROMPT_BRANCH_NAME="$(sed -nE 's/ref: refs\/heads\/(.+)/\1/p' $PROMPT_GIT/HEAD)" || return $?
  PROMPT_BRANCH="$(printf "$PROMPT_BRANCH_FMT" "$PROMPT_BRANCH_NAME")"

  if ! git diff --exit-code --quiet; then
    PROMPT_BRANCH_CHANGES="$(printf "$PROMPT_BRANCH_CHANGES_FMT" "*")"
  else
    PROMPT_BRANCH_CHANGES=""
  fi

  return 0
}

_:prompt_cwd() {
  local path
  local offset
    
  [ "$PWD" == "$PROMPT_RAW_CWD" ] && return;

  PROMPT_RAW_CWD="${PWD%/}/"
  PROMPT_CWD=""

  if [[ "${PROMPT_RAW_CWD}" =~ ^"${HOME%/}"(/.*|$) ]]; then
    PROMPT_RAW_CWD="~${BASH_REMATCH[1]}"
  fi

  if [ "${#PROMPT_RAW_CWD}" -ge 46 ]; then
    if [ ! -z "$PROMPT_GIT_PROJECT" ] && [[ "${PROMPT_RAW_CWD}" == "${PROMPT_GIT_PROJECT%/}/"* ]]; then
      PROMPT_CWD="$(basename ${PROMPT_GIT_PROJECT%/})/${PROMPT_RAW_CWD#${PROMPT_GIT_PROJECT%/}/}"
    else
      PROMPT_CWD="${PROMPT_RAW_CWD%/}"
    fi
  else
    PROMPT_CWD="${PROMPT_RAW_CWD%/}"
  fi

  if [ "${#PROMPT_CWD}" -ge 46 ]; then
    IFS='/' read -r -a path <<< "${PROMPT_CWD}"

    if [ "${#path[@]}" -ge 9 ]; then
      PROMPT_CWD="$( ( IFS=/; echo "${path[*]:0:4}/.../${path[*]:0-4}" ) )"
    elif [ "${#path[@]}" -ge 5 ]; then
      PROMPT_CWD="$( ( IFS=/; echo "${path[*]:0:2}/.../${path[*]:0-2}" ) )"
    elif [ "${#path[@]}" -ge 3 ]; then
      PROMPT_CWD="$( ( IFS=/; echo "${path[0]}/.../${path[*]:0-1}" ) )"
    fi
  fi
}

_:prompt_nix() {
  case "$IN_NIX_SHELL" in
    "impure"|"pure")
      [ "$PROMPT_NIX_DRV_NAME" == "$name" ] && return;

      PROMPT_NIX_DRV_NAME="$name"
      PROMPT_NIX_SHELL="$(printf "$PROMPT_NIX_SHELL_FMT" "$name")"
      ;;

    *)
      [ -z "$PROMPT_NIX_DRV_NAME" ] && return;

      PROMPT_NIX_DRV_NAME=""
      PROMPT_NIX_SHELL=""
      ;;
  esac
}

_:prompt_git() {
  local PREVPATH="${PROMPT_GIT_PREVPATH}"
  
  if [[ "$PWD" == "$PROMPT_GIT_PREVPATH" ]] && [[ "$(( NOW - PROMPT_GIT_TIME ))" -le 10 ]]; then
    return
  fi

  PROMPT_GIT_PREVPATH="$PWD"
  PROMPT_GIT_TIME="$NOW"
  
  if [ -d ".git" ]; then
    PROMPT_GIT="$PWD/.git/"
    PROMPT_GIT_PROJECT="$PWD"
    _:prompt_set_branch 2> /dev/null && return 0
  elif [ -f ".git" ]; then
    PROMPT_GIT="$(sed -nE 's/gitdir: (.+).*/\1/p' .git)"
    PROMPT_GIT_PROJECT="$(sed -nE 's/gitdir: (.+)/\1/; s/\/.git\/.+$//p' .git)"
    _:prompt_set_branch 2> /dev/null && return 0
  elif [ ! -z "$PROMPT_GIT" ] && [[ "$PWD" == "${PROMPT_GIT%.git*}"* ]]; then
    _:prompt_set_branch 2> /dev/null && return 0
  else
    PROMPT_GIT="$(git rev-parse --show-superproject-working-tree --show-toplevel 2> /dev/null || return 0 | head -1)/.git/" || return 0
    PROMPT_GIT_PROJECT="${PROMPT_GIT%.git*}"
    _:prompt_set_branch 2> /dev/null && return 0
  fi

  PROMPT_GIT=""
  PROMPT_GIT_PROJECT=""
  PROMPT_BRANCH=""
  PROMPT_BRANCH_CHANGES=""
}

_:prompt_command() {
  local NOW="$(date +%s)"
  local status_code="$1"

  if [ "$PS1" == '\s-\v\$ ' ]; then
    export PS1="$PROMPT_FMT"
  fi

  if [ "$PROMPT_STATUS_CODE" != "$status_code" ]; then
    if [ "$status_code" -ne "0" ]; then
      PROMPT_STATUS_CODE="$status_code"
      PROMPT_STATUS="$(printf "$PROMPT_STATUS_FMT" "$status_code")"
    else
      PROMPT_STATUS=""
    fi
  fi

  for cmd in $PROMPT_COMMAND_ADDITIONAL; do
    "_:$cmd"
  done
  
  return $status_code
}

_:prompt_command $1

return $1
