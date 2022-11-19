export LC_ALL=en_US.UTF-8
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/local/nvim/bin:$PATH

export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_CONFIG_HOME=$HOME/.config
export BROWSER=/usr/bin/brave
export TERMINAL=/usr/bin/kitty
export EDITOR=$HOME/local/nvim/bin/nvim
export VISUAL=$HOME/local/nvim/bin/nvim

export MANPAGER="nvim +Man!"
export MANWIDTH=100
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# FZF
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"

# lf
. $HOME/bin/lf_icons
export PATH=$HOME/local/lfimg:$PATH

# Go
export PATH=$(go env GOPATH)/bin:$PATH

# Rust
export PATH=$HOME/.cargo/bin:$PATH

# zk
export ZK_NOTEBOOK_DIR=$HOME/data/notes

# Solana
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# Avm
export PATH=$HOME/.avm/bin:$PATH
