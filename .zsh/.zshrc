#
# ~/.zshrc
#

### return if non-interactive shell
[[ $- != *i* ]] && return

### Optimus Manager
## Do "ndavid ALL=(ALL) NOPASSWD: /usr/bin/prime-switch" in sudoers
alias startx='exec sh -c "startx ; sudo /usr/bin/prime-switch"'

### options
setopt no_beep

### tab completion
zmodload zsh/complist
autoload -U compinit && compinit
zstyle ':completion:*' menu select
_comp_options+=(globdots) # include hidden files
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

### history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt append_history

### umask
umask 077

### vi mode
# bindkey -v
# export KEYTIMEOUT=1

### zsh-vi-mode plugin
# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false

### edit with nvim
# autoload edit-command-line; zle -N edit-command-line
# bindkey '^e' edit-command-line
# bindkey '^?' backward-delete-char # make backspace erase chars when switching modes

### Prompt
autoload -U colors && colors

# Colors/Style
_p_bold='%B'
_p_underline='%U'
_p_clear='%f%k%b%u'
if [[ $TERM = linux ]]; then
  _p_blue="$_p_bold%F{blue}"
  _p_git="$_p_bold%F{cyan}"
else
  _p_blue='%F{12}'
  _p_git='%F{47}'
fi
[[ $UID -eq 0 ]] && _p_pwd="$_p_bold%F{red}" || _p_pwd="$_p_blue"
[[ $TERM = linux ]] && dirty="*" staged="+" || dirty="" staged="✔"

_p() {
  p="$_p_pwd%~$_p_clear"

  local git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $git_branch ]]; then
    p+=" ["
    if [[ $git_branch =~ ^(main|master)$ ]] ; then
      p+="$_p_git$git_branch$_p_clear"
    else p+="$git_branch"; fi

    # dirty working tree & staged differences
    git diff --no-ext-diff --quiet 2>/dev/null || p+="$_p_bold%F{1}$dirty"
    git diff-index --cached --quiet HEAD 2>/dev/null || p+="$_p_bold%F{2}$staged"
    p+="$_p_clear]"
  fi

  # p+=$'\n'
  [[ $UID -eq 0 ]] && p+='#' || p+='$'
  PROMPT="${p} "
}

### precmd
precmd() {
  _p;
  print -Pn "\e]2;${SHELL##*/} %~\a"; # set title
}

### preexec
preexec() {
  print -n "\\e]2;$3\\a"; # set title
}

### aliases
alias g='git'
alias ls='ls --color=auto -N'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias lf='lfrun'
alias wh='wormhole send -c 8'
alias torifyme='systemctl status tor; . torsocks'
alias veracrypt='veracrypt -t'
alias ffprobe='ffprobe -hide_banner'

### nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### fzf
f() {
  local file="$(fzf-tmux -1 --tac --tiebreak=index)"
  [[ -n $file ]] && cd "$(dirname "$file")"
}

### motd
[[ $- =~ l ]] && [[ $TERM = linux ]] && . $HOME/bin/motd && . $HOME/bin/woprfetch

### plugins
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh 2>/dev/null
# zsh-syntax-highlighting must be at the end of `.zshrc`
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
