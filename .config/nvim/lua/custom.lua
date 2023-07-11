-- Execute neovim custom settings from current file contents, e.g.
-- :NVIM_CUSTOM: echo "Hello, World!"
vim.keymap.set('n', '<leader>cc', function()
  local keyword = 'NVIM_CUSTOM'
  local keystr = ':' .. keyword .. ':'
  local commands = vim
    .iter(vim.fn.readfile(vim.fn.expand('%:p')))
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
