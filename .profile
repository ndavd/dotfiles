export LC_ALL=en_US.UTF-8
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/local:$PATH
export PATH=$HOME/local/nvim/bin:$PATH
export PATH=$HOME/local/ghostty/bin:$PATH
export PATH=$HOME/bin:$PATH

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
export FZF_DEFAULT_COMMAND="fd --unrestricted --full-path --color=always -E '/.*' -E node_modules -E .git -E target"
export FZF_DEFAULT_OPTS="
  --ansi
  --info=inline
  --color=gutter:#000000
  --no-scrollbar
  --border=none
  --preview='$HOME/.config/fzf/preview {}'
  --preview-window=right,50%,border-left
"

# Go
export PATH=$(go env GOPATH)/bin:$PATH
export GOPATH=$(go env GOPATH)

# Solana
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# Avm
export PATH="$HOME/.avm/bin:$PATH"

# NPM
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

# Foundry
export PATH="$HOME/.config/.foundry/bin:$PATH"

# Huff
export PATH="$HOME/.huff/bin:$PATH"

# Cyfrinup
export PATH="$HOME/.cyfrin/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Noirup
export NARGO_HOME="/home/ndavd/.nargo"
export PATH="$NARGO_HOME/bin:$PATH"
