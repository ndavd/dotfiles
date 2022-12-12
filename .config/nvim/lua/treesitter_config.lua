require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  -- indent = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
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
