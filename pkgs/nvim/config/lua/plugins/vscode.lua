require('vscode').setup({
  style = 'dark',
  transparent = true,
  disable_nvimtree_bg = true,
})

require('aug').add({ 'ColorScheme' }, {
  pattern = 'vscode',
  callback = function()
    vim.cmd([[
      " MatchParen
      hi MatchParen guibg=#303030
    ]])
  end,
})
