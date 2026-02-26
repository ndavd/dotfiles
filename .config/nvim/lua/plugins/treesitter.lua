require('nvim-treesitter').setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

require('ts_context_commentstring').setup({
  enable_autocmd = false,
})

-- Folds
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
vim.o.foldlevelstart = 99

-- Indents
vim.o.indentexpr = 'v:lua.require\'nvim-treesitter\'.indentexpr()'

-- Highlights
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
