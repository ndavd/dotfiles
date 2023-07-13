local nonicons_extention = require('nvim-nonicons.extentions.nvim-tree')

require('nvim-tree').setup({
  filters = {
    dotfiles = true,
  },
  renderer = {
    icons = {
      glyphs = nonicons_extention.glyphs,
    },
  },
})

local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require('nvim-tree.api').tree.open()
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
