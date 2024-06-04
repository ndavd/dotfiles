local oil = require('oil')
local util = require('oil.util')

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
    ['<C-p>'] = {
      desc = 'Open the entry under the cursor in a preview window, or close the preview window if already open',
      callback = function()
        local entry = oil.get_cursor_entry()
        if not entry then
          vim.notify('Could not find entry under cursor', vim.log.levels.ERROR)
          return
        end
        local winid = util.get_preview_win()
        if winid then
          local cur_id = vim.w[winid].oil_entry_id
          if entry.id == cur_id then
            vim.api.nvim_win_close(winid, true)
            return
          end
        end
        oil.open_preview({
          split = 'belowright',
        })
      end,
    },
  },
})
