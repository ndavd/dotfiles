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

  -- Better matchit --
  {
    'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },

  -- Indentation --
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
      {
        'hrsh7th/vim-vsnip',
        config = function()
          local jumpable_n = vim.fn['vsnip#jumpable'](1)
          local jumpable_p = vim.fn['vsnip#jumpable'](-1)
          vim.keymap.set({ 'i', 's' }, '<C-k>', function()
            return jumpable_n and '<Plug>(vsnip-jump-next)' or '<C-k>'
          end, { expr = true })
          vim.keymap.set({ 'i', 's' }, '<C-j>', function()
            return jumpable_p and '<Plug>(vsnip-jump-prev)' or '<C-j>'
          end, { expr = true })
        end,
      },
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
}

local opts = {}

require('lazy').setup(plugins, opts)
require('lazy.view.config').keys.close = '<Esc>'
