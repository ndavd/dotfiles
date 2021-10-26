export LC_ALL=en_US.UTF-8
export PATH=$HOME/local/nvim/bin:$PATH

export XDG_CONFIG_HOME=$HOME/.config
export BROWSER=/usr/bin/brave
export EDITOR=$HOME/local/nvim/bin/nvim
export VISUAL=$HOME/local/nvim/bin/nvim

# npm - Allow user-wide installations
PATH="$HOME/.local/bin:$PATH"
export npm_config_prefix="$HOME/.local"

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
