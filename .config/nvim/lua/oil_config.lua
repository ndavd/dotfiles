local oil = require('oil')

oil.setup({
  default_file_explorer = true,
  keymaps = {
    ['gd'] = {
      desc = 'Drag and drop entry under the cursor',
      callback = function()
        local entry = oil.get_cursor_entry()
        local dir = oil.get_current_dir()
        if not entry or not dir then
          return
        end
        local command = 'dragon-drop'
        local path = dir .. entry.name
        vim.system({ command, path })
      end,
    },
  },
})
