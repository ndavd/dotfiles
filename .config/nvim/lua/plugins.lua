-- Bootstrapping
local fn = vim.fn
local execute = vim.api.nvim_command
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute(
    '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path
  )
end

require('packer').config = {
  profile = {
    enable = true,
    threshold = 1,
  },
}

-- Plugins
return require('packer').startup(function(use)
  -- Packer --
  use('wbthomason/packer.nvim')

  -- Mini all things --
  use('echasnovski/mini.nvim')

  -- Icon support --
  use({
    'yamatsum/nvim-nonicons',
    requires = { 'nvim-tree/nvim-web-devicons' },
  })

  -- Better start screen --
  use({ 'mhinz/vim-startify' })

  -- Better matchit --
  use('andymass/vim-matchup')

  -- Indentation --
  use('tpope/vim-sleuth')

  -- Startuptime --
  use('dstein64/vim-startuptime')

  -- RFC --
  use('mhinz/vim-rfc')

  -- Cheat.sh --
  use('dbeniamine/cheat.sh-vim')

  -- Color picker --
  use('ziontee113/color-picker.nvim')

  -- Git --
  use('tpope/vim-fugitive')
  use('mhinz/vim-signify')

  -- Sql.nvim --
  use('tami5/sql.nvim')

  -- Solidity --
  use('tomlion/vim-solidity')

  -- View tags --
  use('simrat39/symbols-outline.nvim')

  -- Telescope --
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-fzf-writer.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-frecency.nvim',
    },
  })

  -- Treesitter --
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = 'windwp/nvim-ts-autotag',
  })
  use('JoosepAlviste/nvim-ts-context-commentstring')

  -- Lua declarations --
  use('ii14/emmylua-nvim')

  -- LSP --
  use('neovim/nvim-lspconfig')
  use('stevearc/conform.nvim')
  use('mfussenegger/nvim-lint')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/cmp-path')
  use('ray-x/cmp-treesitter')
  use('f3fora/cmp-spell')
  use({
    'hrsh7th/cmp-vsnip',
    after = 'nvim-cmp',
    requires = {
      'hrsh7th/vim-vsnip',
      {
        'rafamadriz/friendly-snippets',
        after = 'cmp-vsnip',
      },
    },
  })

  -- Colorschemes --
  use('gruvbox-community/gruvbox')
  use('Mofiqul/vscode.nvim')
  use('catppuccin/nvim')
  use({ 'projekt0n/github-nvim-theme', branch = '0.0.x' })
end)
