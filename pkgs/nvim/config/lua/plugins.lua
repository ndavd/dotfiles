-- Mini all things --
require('plugins/mini')

-- Treesitter --
require('plugins.treesitter')

-- LSP --
require('plugins/cmp')
require('plugins/lspconfig')
require('plugins/conform')
require('plugins/lint')

-- Colorschemes --
require('plugins.vscode')

-- Noir language support --
require('aug').add({ 'FileType' }, {
  pattern = { 'noir' },
  callback = function(ev)
    vim.bo[ev.buf].commentstring = '// %s'
  end,
})
