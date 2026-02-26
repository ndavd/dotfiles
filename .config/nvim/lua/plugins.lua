-- -- Bootstrapping
-- local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- if not vim.uv.fs_stat(lazypath) then
--   vim.fn.system({
--     'git',
--     'clone',
--     '--filter=blob:none',
--     'https://github.com/folke/lazy.nvim.git',
--     '--branch=stable',
--     lazypath,
--   })
-- end
-- vim.opt.rtp:prepend(lazypath)
--
-- local load = function(path)
--   require(path)
-- end

local gh = function(gh_path)
  return 'https://github.com/' .. gh_path
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind, active = ev.data.spec.name, ev.data.kind, ev.data.active

    local treesitter_name = 'nvim-treesitter'
    if name == treesitter_name and (kind == 'install' or kind == 'update') then
      if not active then
        vim.cmd.packadd(treesitter_name)
      end
      vim.cmd('TSInstall')
      vim.cmd('TSUpdate')
    end
  end,
})

-- Mini all things --
vim.pack.add({ gh('echasnovski/mini.nvim') })
require('plugins/mini')

-- Icon support --
vim.pack.add({
  gh('nvim-tree/nvim-web-devicons'),
  gh('yamatsum/nvim-nonicons'),
})
require('plugins/webdevicons')

-- Better file explorer --
vim.pack.add({ gh('stevearc/oil.nvim') })
require('plugins/oil')

-- Automatic indentation --
vim.pack.add({ gh('tpope/vim-sleuth') })
vim.g.sleuth_automatic = 0
vim.keymap.set('n', '<leader><leader>s', '<cmd>Sleuth<CR>')

-- Treesitter --
vim.pack.add({
  gh('windwp/nvim-ts-autotag'),
  gh('JoosepAlviste/nvim-ts-context-commentstring'),
  gh('nvim-treesitter/nvim-treesitter'),
})
require('plugins/treesitter')

-- LSP --
vim.pack.add({
  gh('hrsh7th/cmp-nvim-lsp'),
  gh('neovim/nvim-lspconfig'),
})
require('plugins/lspconfig')
vim.pack.add({ gh('stevearc/conform.nvim') })
require('plugins/conform')
vim.pack.add({ gh('mfussenegger/nvim-lint') })
require('plugins/lint')
vim.pack.add({
  gh('hrsh7th/vim-vsnip'),
  gh('hrsh7th/cmp-vsnip'),
  gh('rafamadriz/friendly-snippets'),
  gh('hrsh7th/cmp-path'),
  gh('ray-x/cmp-treesitter'),
  gh('f3fora/cmp-spell'),
  gh('hrsh7th/nvim-cmp'),
})
require('plugins/cmp')

-- Colorschemes --
vim.pack.add({ gh('Mofiqul/vscode.nvim') })
require('plugins.vscode')

-- Noir language support --
vim.pack.add({ gh('noir-lang/noir-nvim') })

-- local plugins = {
-- -- Mini all things! --
-- {
--   'echasnovski/mini.nvim',
--   config = load('plugins/mini'),
-- },
--
-- -- Icon support --
-- {
--   'yamatsum/nvim-nonicons',
--   dependencies = {
--     {
--       'nvim-tree/nvim-web-devicons',
--       config = load('plugins/webdevicons'),
--     },
--   },
-- },
--
-- -- Better file explorer --
-- {
--   'stevearc/oil.nvim',
--   config = load('plugins/oil'),
-- },
--
-- -- Automatic indentation --
-- {
--   'tpope/vim-sleuth',
--   config = function()
--     vim.g.sleuth_automatic = 0
--     vim.keymap.set('n', '<leader><leader>s', '<cmd>Sleuth<CR>')
--   end,
-- },
--
-- -- Treesitter --
-- {
--   'nvim-treesitter/nvim-treesitter',
--   build = ':TSUpdate',
--   config = load('plugins/treesitter'),
--   dependencies = {
--     'windwp/nvim-ts-autotag',
--     'JoosepAlviste/nvim-ts-context-commentstring',
--   },
-- },
--
-- -- LSP --
-- {
--   'neovim/nvim-lspconfig',
--   config = load('plugins/lspconfig'),
-- },
-- {
--   'stevearc/conform.nvim',
--   config = load('plugins/conform'),
-- },
-- {
--   'mfussenegger/nvim-lint',
--   config = load('plugins/lint'),
-- },
-- {
--   'hrsh7th/nvim-cmp',
--   config = load('plugins/cmp'),
--   dependencies = {
--     'hrsh7th/vim-vsnip',
--     'hrsh7th/cmp-vsnip',
--     'rafamadriz/friendly-snippets',
--     'hrsh7th/cmp-nvim-lsp',
--     'hrsh7th/cmp-path',
--     'ray-x/cmp-treesitter',
--     'f3fora/cmp-spell',
--   },
-- },
--
-- -- Colorschemes --
-- {
--   'Mofiqul/vscode.nvim',
--   config = load('plugins.vscode'),
-- },
--
-- -- Noir language --
-- 'noir-lang/noir-nvim',
-- }

-- local opts = {}
--
-- require('lazy').setup(plugins, opts)
-- require('lazy.view.config').keys.close = '<Esc>'
