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

# Colors/Style
_p_clear='\[\e[0m\]'
_p_green='\[\e[38;5;02m\]'
_p_bold='\[\e[1m\]'
_p_italic='\[\e[3m\]'
_p_underline='\[\e[4m\]'
_p_git='\[\e[38;5;47m\]'
_p_rootud='\[\e[38;5;9m\]'
_p_ud='\[\e[38;5;02m\]'
_p_pwd='\[\e[38;5;12m\]'

_git_c() {
  local git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $git_branch ]]; then
    # dirty working tree & staged differences
    local changes=
    git diff --no-ext-diff --quiet 2>/dev/null || changes+=" $_p_bold*"
    git diff-index --cached --quiet HEAD 2>/dev/null || changes+=" $_p_bold✓"
    if [[ $git_branch =~ ^(main|master)$ ]] ; then
      echo " $_p_git$git_branch$_p_clear$changes$_p_clear"
    else
      echo " $git_branch$changes$_p_clear"
    fi
  else
    echo ""
  fi
}

_p() {
  # PS1="$_p_rootud\u@\h$_p_clear:$_p_pwd\w$_p_clear$(_git_c)\$ "
  PS1="$_p_pwd\w$_p_clear$(_git_c)\\$ "
}
PROMPT_COMMAND=_p

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

# Enable history appending instead of overwriting
shopt -s histappend

# ESC to use vi mode
set -o vi

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

neofetch
# pfetch
