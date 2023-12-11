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
    config = load('mini_config'),
  },

  -- Icon support --
  {
    'yamatsum/nvim-nonicons',
    dependencies = {
      {
        'nvim-tree/nvim-web-devicons',
        config = load('webdevicons_config'),
      },
    },
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

  -- RFC --
  'mhinz/vim-rfc',

  -- Cheat.sh --
  'dbeniamine/cheat.sh-vim',

  -- Color picker --
  {
    'ziontee113/color-picker.nvim',
    config = load('colorpicker_config'),
  },

  -- Git --
  'tpope/vim-fugitive',
  {
    'mhinz/vim-signify',
    config = function()
      local symbol = '▌'
      vim.g.signify_sign_add = symbol
      vim.g.signify_sign_change = symbol
      vim.g.signify_sign_delete = symbol
    end,
  },

  -- Treesitter --
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = load('treesitter_config'),
    dependencies = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },

  -- LSP --
  {
    'neovim/nvim-lspconfig',
    config = load('lspconfig_config'),
  },
  {
    'stevearc/conform.nvim',
    config = load('conform_config'),
  },
  {
    'mfussenegger/nvim-lint',
    config = load('lint_config'),
  },
  {
    'hrsh7th/nvim-cmp',
    config = load('cmp_config'),
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
require('lazy.view.config').keys.close = '<Esc>'
