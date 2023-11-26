local nbsc = ' '
local show_ln = false

local hl_groups = {
  stl = 'StatusLine',
  icon = 'StatusLineIcon',
  branch_main = 'StatusLineBranchMain',
  branch_others = 'StatusLineBranchOthers',
  mode_normal = 'StatusLineModeNormal',
  mode_insert = 'StatusLineModeInsert',
  mode_replace = 'StatusLineModeReplace',
  mode_visual = 'StatusLineModeVisual',
}

local parse_hl_group = function(str)
  return '%#' .. str .. '#'
end

local file_modified = function()
  if not vim.o.modifiable then
    return '[-]'
  end
  if vim.o.modified then
    return '[+]'
  end
  return ''
end

local git_branch = function()
  local b = vim.fn.FugitiveHead(8)
  local hl
  if vim.tbl_contains({ 'main', 'master' }, b) then
    hl = parse_hl_group(hl_groups.branch_main)
  else
    hl = parse_hl_group(hl_groups.branch_others)
  end
  if b ~= '' then
    b = ('%s[%s]'):format(nbsc, b)
  end
  return '%<' .. hl .. b .. '%*'
end

local git_status = function()
  local stats = vim.fn['sy#repo#get_stats']()
  local status = {}
  if stats[1] > 0 then
    table.insert(status, '+' .. stats[1])
  end
  if stats[3] > 0 then
    table.insert(status, '-' .. stats[3])
  end
  if stats[2] > 0 then
    table.insert(status, '~' .. stats[2])
  end
  stats = table.concat(status, ',')
  if stats == '' then
    return ''
  end
  return ('[%s]'):format(stats)
end

local mode = function()
  local m = vim.fn.mode()
  local modes = {
    n = 'NORMAL' .. nbsc .. nbsc,
    i = 'INSERT' .. nbsc .. nbsc,
    R = 'REPLACE' .. nbsc,
    v = 'VISUAL' .. nbsc .. nbsc,
    V = 'V·LINE' .. nbsc .. nbsc,
    c = 'COMMAND' .. nbsc,
    s = 'SELECT' .. nbsc .. nbsc,
    S = 'S·LINE' .. nbsc .. nbsc,
    [''] = 'V·BLOCK' .. nbsc,
    [''] = 'S·BLOCK' .. nbsc,
  }
  local hl
  if vim.tbl_contains({ 'n', 'c' }, m) then
    hl = hl_groups.mode_normal
  elseif vim.tbl_contains({ 'i', 'ix', 's', 'S', '' }, m) then
    hl = hl_groups.mode_insert
  elseif vim.tbl_contains({ 'R' }, m) then
    hl = hl_groups.mode_replace
  elseif vim.tbl_contains({ 'v', 'V', '' }, m) then
    hl = hl_groups.mode_visual
  end
  hl = parse_hl_group(hl)
  local prefixes = {
    i = '∧∧',
    R = 'vv',
  }
  local prefix = prefixes[m] or '>>'
  return hl .. nbsc .. '%-11 ' .. prefix .. nbsc .. modes[m] .. '%*'
end

local filepath = function()
  local icon = require('webdevicons_config').get_icon({
    do_hl = { true, hl_groups.stl, hl_groups.icon },
  })
  return icon .. vim.fn.expand('%f')
end

local line_stats = function()
  if not show_ln then
    return ''
  end

  local curr_line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  local percentage = (curr_line / total_lines) * 100
  local curr_col = vim.fn.col('.')
  return ('%%= %s(%s%%%%):%s'):format(
    curr_line,
    math.floor(percentage),
    curr_col
  )
end

local greeting = function()
  local parts = { 'evening', 'morning', 'afternoon', 'evening' }
  local hour = tonumber(vim.fn.strftime('%H'))
  local day_part = parts[math.floor((hour + 4) / 8) + 1]
  local username = vim.uv.os_get_passwd()['username']

  return ('Good %s, %s'):format(day_part, username)
end

Stl = function()
  local ft = vim.o.ft
  local bt = vim.o.bt
  if ft == 'starter' then
    return ('%%= %s %%='):format(greeting())
  end
  if ft == 'lazy' then
    return '%= 📦 Lazy %='
  end
  if ft == 'minipick' then
    return '%= 🔭 Pick %='
  end
  if bt == 'terminal' then
    return '%=  terminal %='
  end
  return mode()
    .. filepath()
    .. file_modified()
    .. git_branch()
    .. git_status()
    .. nbsc
    .. line_stats()
end

vim.go.stl = '%!v:lua.Stl()'
vim.keymap.set('n', '<leader>sl', function()
  show_ln = not show_ln
  vim.cmd('redrawstatus')
end, { silent = true })
