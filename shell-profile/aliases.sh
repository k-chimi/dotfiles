export TERM=xterm-256color
export COLORTERM=truecolor
if [ -z "$LANG" ]; then
  export LANG=C.UTF-8
fi

if which dircolors &> /dev/null; then
  eval "$(dircolors -b)"
  
  alias ls="ls --color=auto"

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if which lesspipe &> /dev/null; then
  eval "$(lesspipe)"
fi
