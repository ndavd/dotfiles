require('color-picker').setup({
  icons = { 'ﱢ', '' },
  keymap = {
    ['U'] = '<Plug>Slider5Decrease',
    ['O'] = '<Plug>Slider5Increase',
  },
})
vim.keymap.set('n', '<C-c>', '<cmd>PickColor<CR>', { silent = true })
vim.keymap.set('i', '<C-c>', '<cmd>PickColorInsert<CR>', { silent = true })
