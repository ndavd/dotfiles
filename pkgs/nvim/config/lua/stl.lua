local nbsc = ' '

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
  local b = vim.b.minigit_summary_string or ''
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
  return vim.b.minidiff_summary_string or ''
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
  if vim.tbl_contains({ 'i', 'ix', 's', 'S', '' }, m) then
    hl = hl_groups.mode_insert
  elseif vim.tbl_contains({ 'R' }, m) then
    hl = hl_groups.mode_replace
  elseif vim.tbl_contains({ 'v', 'V', '' }, m) then
    hl = hl_groups.mode_visual
  else
    hl = hl_groups.mode_normal
  end
  hl = parse_hl_group(hl)
  local prefixes = {
    i = '∧∧',
    R = 'vv',
  }
  local prefix = prefixes[m] or '>>'
  return hl .. nbsc .. '%-11 ' .. prefix .. nbsc .. (modes[m] or '') .. '%*'
end

local filepath = function()
  local icon, hl = require('mini.icons').get('file', vim.fn.expand('%'))
  return parse_hl_group(hl) .. icon .. '%* ' .. vim.fn.expand('%f')
end

Stl = function()
  local ft = vim.o.ft
  local bt = vim.o.bt
  if ft == 'ministarter' then
    return '%= NVIM %='
  end
  if ft == 'lazy' then
    return '%= 📦 Lazy %='
  end
  if ft == 'minifiles' then
    return ' 📂 Explorer %='
  end
  if ft == 'minipick' then
    return '%= 🔭 Pick %='
  end
  if bt == 'terminal' then
    return '%=  terminal %='
  end
  return mode() .. filepath() .. file_modified() .. git_branch() .. git_status() .. nbsc
end

vim.o.fillchars = 'stl:-,stlnc:-'
vim.o.laststatus = 3
vim.o.stl = '%!v:lua.Stl()'
