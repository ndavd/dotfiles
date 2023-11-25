-- Setup nonicons
local nonicons = require('nvim-nonicons')
nonicons.setup()

local devicons = require('nvim-web-devicons')

local out = {}

-- From https://github.com/yamatsum/nvim-nonicons/blob/main/lua/nvim-web-devicons/override.lua
local nonicons_palette = {
  orange = '#d18616',
  black = '#586069',
  bright_black = '#959da5',
  white = '#d1d5da',
  bright_white = '#fafbfc',
  red = '#ea4a5a',
  bright_red = '#f97583',
  green = '#34d058',
  bright_green = '#85e89d',
  yellow = '#ffea7f',
  bright_yellow = '#ffea7f',
  blue = '#2188ff',
  bright_blue = '#79b8ff',
  magenta = '#b392f0',
  bright_magenta = '#b392f0',
  cyan = '#39c5cf',
  bright_cyan = '#56d4dd',
}
local test_icon = '󰙨'

devicons.setup({
  default = true,
  override_by_extension = {
    ['test.js'] = {
      icon = test_icon,
      color = nonicons_palette.yellow,
      name = 'TestJs',
    },
    ['test.jsx'] = {
      icon = test_icon,
      color = nonicons_palette.bright_blue,
      name = 'JavaScriptReactTest',
    },
    ['test.ts'] = {
      icon = test_icon,
      color = nonicons_palette.bright_blue,
      name = 'TestTs',
    },
    ['test.tsx'] = {
      icon = test_icon,
      color = nonicons_palette.bright_blue,
      name = 'TypeScriptReactTest',
    },
    ['txt'] = {
      icon = nonicons.get('file'),
      color = nonicons_palette.bright_black,
      name = 'Text',
    },
  },
})

local STORE_HL

-- If we don't do this when sourcing init.vim the filetype icon does not update
if STORE_HL ~= nil then
  vim.cmd(STORE_HL)
end

-- Example: get_icon{filepath="foo/bar.vim"}
out.get_icon = function(opts)
  --[[ do_hl is an array, index 1 is a boolean
  if do_hl[1] is true then index 2 is the hl_group of the statusline
  and index 3 is the hl_group of the icon --]]
  local do_hl = opts.do_hl
  local filepath = opts.filepath
  local filename, output
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
    filename = path[#path]
  else
    filename = vim.fn.expand('%:t')
  end
  local icon, hl_group = require('nvim-web-devicons').get_icon(filename)
  icon = icon .. ' '
  if do_hl[1] then
    local guifg =
      vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_group)), 'fg')
    if guifg == '' then
      guifg = ''
    else
      guifg = ' guifg=' .. guifg
    end
    local guibg =
      vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(do_hl[2])), 'bg')
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

out.print_icons = function(compact)
  if compact == nil then
    compact = true
  end
  local icons_table = vim
    .iter(require('nvim-nonicons.mapping'))
    :map(function(icon_name)
      local icon = nonicons.get(icon_name)
      if compact then
        return icon .. ' '
      end
      return nonicons.get(icon_name) .. ' ' .. icon_name
    end)
    :totable()
  print(table.concat(icons_table, ':'))
end

return out
