-- Bootstrapping
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Mini all things! --
  'echasnovski/mini.nvim',

  -- Icon support --
  {
    'yamatsum/nvim-nonicons',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Better matchit --
  'andymass/vim-matchup',

  -- Indentation --
  'tpope/vim-sleuth',

  -- RFC --
  'mhinz/vim-rfc',

  -- Cheat.sh --
  'dbeniamine/cheat.sh-vim',

  -- Color picker --
  'ziontee113/color-picker.nvim',

  -- Git --
  'tpope/vim-fugitive',
  'mhinz/vim-signify',

  -- Sql.nvim --
  'tami5/sql.nvim',

  -- Solidity --
  'tomlion/vim-solidity',

  -- Treesitter --
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },

  -- Lua declarations --
  'ii14/emmylua-nvim',

  -- LSP --
  'neovim/nvim-lspconfig',
  'stevearc/conform.nvim',
  'mfussenegger/nvim-lint',
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'f3fora/cmp-spell',
    },
  },

  -- Colorschemes --
  'gruvbox-community/gruvbox',
  'Mofiqul/vscode.nvim',
  'catppuccin/nvim',
  { 'projekt0n/github-nvim-theme', branch = '0.0.x' },
}

local opts = {}

require('lazy').setup(plugins, opts)
