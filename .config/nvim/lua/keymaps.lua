local keymap = vim.keymap.set

-- Window handling
keymap('n', '<leader>h', '<cmd>wincmd h<CR>')
keymap('n', '<leader>j', '<cmd>wincmd j<CR>')
keymap('n', '<leader>k', '<cmd>wincmd k<CR>')
keymap('n', '<leader>l', '<cmd>wincmd l<CR>')
keymap('n', '<leader>x', '<cmd>wincmd c<CR>')
keymap('n', '<leader>T', '<cmd>wincmd T<CR>')
keymap('n', '<leader>=', '<cmd>wincmd =<CR>')
keymap('n', '<leader>o', '<cmd>wincmd o<CR>')
keymap('n', '<leader>sv', '<cmd>wincmd v<CR>')
keymap('n', '<leader>sh', '<cmd>wincmd s<CR>')

-- Scroll up/down with keys
keymap('n', '<C-j>', '<C-e>')
keymap('n', '<C-k>', '<C-y>')

-- Scroll left/right with keys
keymap('n', '<C-h>', '3zh')
keymap('n', '<C-l>', '3zl')

-- Formatting
keymap('n', 'gqf', 'mmgggqG`m')

-- Tab handling
keymap('n', '<leader>tc', '<cmd>tabc<CR>')
keymap('n', '<leader>tn', '<cmd>tabn<CR>')
keymap('n', '<leader>tp', '<cmd>tabp<CR>')

-- Activate/deactivate spelllang
keymap('n', '<leader>p', '<cmd>setlocal spell spelllang=en_us<CR>')
keymap('n', '<leader>pt', '<cmd>setlocal spell spelllang=pt_pt<CR>')
keymap('n', '<S-p>', '<cmd>set nospell<CR>')
