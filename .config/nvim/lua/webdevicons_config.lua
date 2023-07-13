-- Setup nonicons
require('nvim-nonicons').setup({})

local out = {}

out.my_setup = function()
  require('nvim-web-devicons').setup({
    default = true,
  })
end

local STORE_HL

-- Example: get_icon{filepath="foo/bar.vim"}
out.get_icon = function(opts)
  --[[ do_hl is an array, index 1 is a boolean
  if do_hl[1] is true then index 2 is the hl_group of the statusline
  and index 3 is the hl_group of the icon --]]
  local do_hl = opts.do_hl
  local filepath = opts.filepath
  local file_extension, output
  if do_hl == nil then
    do_hl = { false }
  end
  if filepath ~= nil then
    local last_char = filepath:sub(-1)
    if last_char == '\\' or last_char == '/' then
      return ''
    end
    local path = vim.fn.split(filepath, '\\')
    path = vim.fn.split(path[#path], '/')
    path = vim.fn.split(path[#path], '\\.')
    file_extension = path[#path]
  else
    file_extension = vim.fn.split(vim.fn.expand('%:t'), '\\.')
    file_extension = file_extension[#file_extension]
  end
  local icon, hl_group = require('nvim-web-devicons').get_icon('foo', file_extension)
  icon = icon .. ' '
  if do_hl[1] then
    local guifg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_group)), 'fg')
    if guifg == '' then
      guifg = ''
    else
      guifg = ' guifg=' .. guifg
    end
    local guibg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(do_hl[2])), 'bg')
    if guibg == '' then
      guibg = ''
    else
      guibg = ' guibg=' .. guibg
    end
    STORE_HL = 'hi ' .. do_hl[3] .. guibg .. guifg
    vim.cmd(STORE_HL)
    output = '%#' .. do_hl[3] .. '#' .. icon .. '%#' .. do_hl[2] .. '#'
  else
    output = icon
  end
  return output
end

--[[
If this function isn't called when sourcing
init.vim the filetype icon does not update --]]
out.make_hl = function()
  if STORE_HL ~= nil then
    vim.cmd(STORE_HL)
  end
end

return out
