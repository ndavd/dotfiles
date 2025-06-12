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

local load = function(path)
  return function()
    require(path)
  end
end

local plugins = {
  -- Mini all things! --
  {
    'echasnovski/mini.nvim',
    config = load('plugins/mini'),
  },

  -- Icon support --
  {
    'yamatsum/nvim-nonicons',
    dependencies = {
      {
        'nvim-tree/nvim-web-devicons',
        config = load('plugins/webdevicons'),
      },
    },
  },

  -- Better file explorer --
  {
    'stevearc/oil.nvim',
    config = load('plugins/oil'),
  },

  -- Automatic indentation --
  {
    'tpope/vim-sleuth',
    config = function()
      vim.g.sleuth_automatic = 0
      vim.keymap.set('n', '<leader><leader>s', '<cmd>Sleuth<CR>')
    end,
  },

  -- Treesitter --
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = load('plugins/treesitter'),
    dependencies = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },

  -- LSP --
  {
    'neovim/nvim-lspconfig',
    config = load('plugins/lspconfig'),
  },
  {
    'stevearc/conform.nvim',
    config = load('plugins/conform'),
  },
  {
    'mfussenegger/nvim-lint',
    config = load('plugins/lint'),
  },
  {
    'hrsh7th/nvim-cmp',
    config = load('plugins/cmp'),
    dependencies = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'f3fora/cmp-spell',
    },
  },

  -- Colorschemes --
  {
    'Mofiqul/vscode.nvim',
    config = load('plugins.vscode'),
  },

  -- Noir language --
  'noir-lang/noir-nvim',
}

local opts = {}

require('lazy').setup(plugins, opts)
require('lazy.view.config').keys.close = '<Esc>'
