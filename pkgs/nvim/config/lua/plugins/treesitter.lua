local nvim_treesitter = require('nvim-treesitter')

nvim_treesitter.setup({})

require('ts_context_commentstring').setup({
  enable_autocmd = false,
})

require('aug').add('FileType', {
  callback = function()
    local success = pcall(vim.treesitter.start)
    if success then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.bo.indentexpr = 'v:lua.require\'nvim-treesitter\'.indentexpr()'
    end
  end,
})
