#
# ~/.zshrc
#

### return if non-interactive shell
[[ $- != *i* ]] && return

### Optimus Manager
# # Do "ndavid ALL=(ALL) NOPASSWD: /usr/bin/prime-switch" in sudoers
# alias xinit='exec sh -c "xinit ; sudo /usr/bin/prime-switch"'

### options
setopt no_beep
setopt hist_ignore_space

### tab completion
zmodload zsh/complist
autoload -U compinit && compinit
zstyle ':completion:*' menu select
_comp_options+=(globdots) # include hidden files
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M isearch '^M' accept-search

### history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt append_history

### umask
umask 077

### fix permissions of current folder recursively
fix-perm () {
  if [[ $1 = -h ]]; then
    echo 'usage: fix-perm [dirs:700] [files:600]' >&2
    return 1
  fi
  if [[ $PWD = $HOME ]]; then
    echo 'Do not run this from the home directory!' >&2
    return 1
  fi
  find . -type d -exec chmod ${1-700} {} +
  find . -type f -exec chmod ${2-600} {} +
}

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

# tmux
tm() {
  if (( $# )); then
    tmux has-session -t "$*" && tmux attach -t "$*" || tmux new-session -s "$*"
  else
    tmux attach || tmux new-session
  fi
}

### check if console
_isConsole() {
  [[ $TERM =~ "linux|screen" ]] && return 0 || return 1
}

### Prompt
autoload -U colors && colors

# Colors/Style
_p_bold='%B'
_p_underline='%U'
_p_clear='%f%k%b%u'
if _isConsole; then
  _p_blue="$_p_bold%F{blue}"
  _p_git="$_p_bold%F{cyan}"
else
  _p_blue='%F{12}'
  _p_git='%F{47}'
fi
[[ $UID -eq 0 ]] && _p_pwd="$_p_bold%F{red}" || _p_pwd="$_p_blue"
_isConsole && dirty="*" staged="+" || dirty="" staged="✔"

_p() {
  p="$_p_pwd%1~$_p_clear"

  local git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $git_branch ]]; then
    p+="["
    if [[ $git_branch =~ ^(main|master)$ ]] ; then
      p+="$_p_git$git_branch$_p_clear"
    else p+="$git_branch"; fi

    # dirty working tree & staged differences
    git diff --no-ext-diff --quiet 2>/dev/null || p+="$_p_bold%F{1}$dirty"
    git diff-index --cached --quiet HEAD 2>/dev/null || p+="$_p_bold%F{2}$staged"
    p+="$_p_clear]"
  fi

  if _isConsole; then
    [[ $UID -eq 0 ]] && p+="%F{red}#$_p_clear" || p+="$_p_bold%F{yellow}\$$_p_clear"
  else
    [[ $UID -eq 0 ]] && p+="%F{red}₿$_p_clear" || p+="%F{yellow}₿$_p_clear"
  fi
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
alias g="git"
alias ls="ls --color=auto -N"
alias grep="grep --colour=auto"
alias egrep="egrep --colour=auto"
alias fgrep="fgrep --colour=auto"
alias ffprobe="ffprobe -hide_banner"
alias news="newsboat"
alias nvmd="nvm use default"

### nnn
source $HOME/.config/nnn/nnn.sh

### fzf
fzfa() {
  fd --unrestricted --full-path --color=always | fzf
}
f() {
  local dir="$(fd --unrestricted --type d --full-path --color=always -E '/.*' -E node_modules -E .git -E target | fzf)"
  [[ -n $dir ]] && cd "$dir"
}
z() {
  local dirs=(${(f)~"$(<$HOME/.project-dirs)"})
  local dir="$(fd --unrestricted --absolute-path --type d --color=always --min-depth 1 --max-depth 1 . "${dirs[@]}" | sed "s|${HOME}|~|" | fzf)"
  [[ -n $dir ]] && cd $~dir && zellij -l project
}
book() {
  local file="$(fd --unrestricted --color=always . $HOME/data/books | fzf)"
  [[ -n $file ]] && zathura "$file"
}
video() {
  local file="$(fd --no-ignore --color=always --glob '*.{mp4,mkv,mpeg,webm,avi,h264,mov,wmv}' $HOME/data/videos | fzf)"
  [[ -n $file ]] && mpv "$file"
}

### motd
[[ $- =~ l ]] && [[ $TERM == linux ]] && . $HOME/bin/motd && . $HOME/bin/woprfetch

### nvm
export NVM_DIR="$HOME/.config/nvm"
_nvm_lazyload() {
  for cmd in "$@"; do
    alias $cmd="unalias $*; [[ -s $NVM_DIR/nvm.sh ]] && . $NVM_DIR/nvm.sh && $cmd"
  done
}
_nvm_lazyload nvm node npm npx yarn corepack

### opam configuration
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

### plugins
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh 2>/dev/null
# zsh-syntax-highlighting must be at the end of `.zshrc`
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# tabtab source for packages
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
