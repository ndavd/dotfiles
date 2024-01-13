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
keymap('n', '<leader><S-p>', '<cmd>set nospell<CR>')

-- Execute neovim custom settings from current file contents, e.g.
-- :NVIM_CUSTOM: echo "Hello, World!"
keymap('n', '<leader>cc', function()
  local keyword = 'NVIM_CUSTOM'
  local keystr = ':' .. keyword .. ':'
  local commands = vim
    .iter(vim.fn.readfile(tostring(vim.fn.expand('%:p'))))
    :map(function(line)
      local index = string.find(line, keystr)
      if index ~= nil then
        return string.sub(line, index + #keystr)
      end
    end)
    :totable()
  if #commands == 0 then
    print('Couldn\'t find any custom NVIM settings...')
    return
  end
  local success = pcall(vim.api.nvim_exec2, table.concat(commands, '\n'), {})
  if success then
    print('Loaded ' .. #commands .. 'l of custom NVIM settings')
  end
end)

-- Cycle listchars
if vim.o.list then
  local listchar_index = 1
  local l = 'tab:_\\ ,conceal:┊,nbsp:⍽,extends:>,precedes:<,trail:·'
  local listchar_options = { l .. ',eol:﬋', l, '' }
  local cycle_listchars = function()
    vim.o.listchars = listchar_options[listchar_index]
    listchar_index = (listchar_index % #listchar_options) + 1
  end
  keymap('n', '<leader><leader>cl', cycle_listchars)
  cycle_listchars()
end
