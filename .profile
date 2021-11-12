export LC_ALL=en_US.UTF-8
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/local/nvim/bin:$PATH

export XDG_CONFIG_HOME=$HOME/.config
export BROWSER=/usr/bin/brave
export EDITOR=$HOME/local/nvim/bin/nvim
export VISUAL=$HOME/local/nvim/bin/nvim

export MANPAGER="nvim +Man!"
export MANWIDTH=100
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# change theme
export PATH=$HOME/local/chtheme:$PATH

# FZF
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"

# lf
. $HOME/bin/lf_icons
export PATH=$HOME/local/lfimg:$PATH

# Go
export PATH=$HOME/go/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
