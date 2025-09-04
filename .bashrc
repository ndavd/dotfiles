#
# ~/.bashrc
#

### return if non-interactive shell
[[ $- != *i* ]] && return

### Optimus Manager
## Do "ndavid ALL=(ALL) NOPASSWD: /usr/bin/prime-switch" in sudoers
alias startx='exec sh -c "startx ; sudo /usr/bin/prime-switch"'

umask 077

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[[ -n $KITTY_WINDOW_ID ]] && trap 'printf "\033]0;%s\007" "${BASH_COMMAND/_p/bash}"' DEBUG

use_color=true

### check if console
_isConsole() {
  [[ "$TERM" =~ (linux|screen) ]] && return 0 || return 1
}

# Colors/Style

_bold="\[\e[1m\]"
_underline="\[\e[4m\]"
_clear="\[\e[0m\]"
if _isConsole; then
  _blue="${_bold}\[\e[34m\]"
  _git="${_bold}\[\e[36m\]"
else
  _blue="\[\e[38;5;12m\]"
  _git="\[\e[38;5;47m\]"
fi

if [[ $UID -eq 0 ]]; then
  _pwd="${_bold}\[\e[31m\]"
else
  _pwd="$_blue"
fi

_short_pwd() {
  if [[ "$PWD" == "$HOME" ]]; then
    printf "~"
  else
    basename "$PWD"
  fi
}

if _isConsole; then
  dirty="*"
  staged="+"
else
  dirty=""
  staged="✔"
fi

_prompt_command() {
  if [[ $SHELL == /nix* ]]; then
    _nix_prefix="\[\e[36m\]<nix>\[\e[0m\]"
  else
    _nix_prefix=""
  fi
  local p="${_nix_prefix}${_pwd}$(_short_pwd)${_clear}"

  local git_branch
  git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $git_branch ]]; then
    p+="["

    if [[ $git_branch =~ ^(main|master)$ ]]; then
      p+="${_git}${git_branch}${_clear}"
    else
      p+="$git_branch"
    fi

    git diff --no-ext-diff --quiet 2>/dev/null || p+="${_bold}\[\e[31m\]$dirty${_clear}"
    git diff-index --cached --quiet HEAD 2>/dev/null || p+="${_bold}\[\e[32m\]$staged${_clear}"

    p+="]"
  fi

  if _isConsole; then
    if [[ $UID -eq 0 ]]; then
      p+="\[\e[31m\]#${_clear}"
    else
      p+="${_bold}\[\e[33m\]\$${_clear}"
    fi
  else
    if [[ $UID -eq 0 ]]; then
      p+="\[\e[31m\]₿${_clear}"
    else
      p+="\[\e[33m\]₿${_clear}"
    fi
  fi

  PS1="${p} "
}

PROMPT_COMMAND=_prompt_command

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

# Enable history appending instead of overwriting
shopt -s histappend

# ESC to use vi mode
set -o vi

# clear shell with ^L
bind '"\C-l": clear-screen'

# aliases
alias g='git'
alias ls='ls --color=auto -Nv'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf
f() {
  local file="$(fzf-tmux -1 --tac --tiebreak=index)"
  [[ -n $file ]] && cd "$(dirname "$file")"
}

# fastfetch
# pfetch
