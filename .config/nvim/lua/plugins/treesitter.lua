-- Folds
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldtext = ''
vim.o.foldlevelstart = 99

require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  -- indent = { enable = true },
  autotag = { enable = true },
  highlight = {
    enable = true,
    disable = { 'markdown' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
})

require('ts_context_commentstring').setup({
  enable_autocmd = false,
})
