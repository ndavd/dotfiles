-- Window handling
vim.keymap.set('n', '<space>h', '<cmd>wincmd h<CR>')
vim.keymap.set('n', '<space>j', '<cmd>wincmd j<CR>')
vim.keymap.set('n', '<space>k', '<cmd>wincmd k<CR>')
vim.keymap.set('n', '<space>l', '<cmd>wincmd l<CR>')
vim.keymap.set('n', '<space>x', '<cmd>wincmd c<CR>')
vim.keymap.set('n', '<space>T', '<cmd>wincmd T<CR>')
vim.keymap.set('n', '<space>=', '<cmd>wincmd =<CR>')
vim.keymap.set('n', '<space>o', '<cmd>wincmd o<CR>')
vim.keymap.set('n', '<space>sv', '<cmd>wincmd v<CR>')
vim.keymap.set('n', '<space>sh', '<cmd>wincmd s<CR>')

-- Scroll up/down with keys
vim.keymap.set('n', '<C-j>', '<C-e>')
vim.keymap.set('n', '<C-k>', '<C-y>')

-- Scroll left/right with keys
vim.keymap.set('n', '<C-h>', '3zh')
vim.keymap.set('n', '<C-l>', '3zl')

-- Formatting
vim.keymap.set('n', 'gqf', 'mmgggqG`m')

-- Tab handling
vim.keymap.set('n', '<leader>tc', '<cmd>tabc<CR>')
vim.keymap.set('n', '<leader>tn', '<cmd>tabn<CR>')
vim.keymap.set('n', '<leader>tp', '<cmd>tabp<CR>')

-- Activate/deactivate spelllang
vim.keymap.set('n', '<leader>p', '<cmd>setlocal spell spelllang=en_us<CR>')
vim.keymap.set('n', '<leader>pt', '<cmd>setlocal spell spelllang=pt_pt<CR>')
vim.keymap.set('n', '<leader><S-p>', '<cmd>set nospell<CR>')
