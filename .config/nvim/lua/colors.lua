--- @param name string
--- @param val vim.api.keyset.highlight
local update_hl = function(name, val)
  vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', val, { update = true }))
end

local none = 0

local make_hls = function()
  update_hl('Comment', { ctermfg = 'DarkBlue' })
  -- Transparent bg
  update_hl('Normal', { bg = none })
  update_hl('NonText', { bg = none })
  update_hl('ModeMsg', { bg = none })
  update_hl('MoreMsg', { bg = none })
  update_hl('ModeArea', { bg = none })
  update_hl('ErrorMsg', { bg = none })
  update_hl('Error', { bg = none })
  update_hl('Directory', { bg = none })
  update_hl('VertSplit', { bg = none })
  update_hl('SignColumn', { bg = none })
  update_hl('EndOfBuffer', { bg = none, fg = '#5a5a5a' })
  update_hl('NormalFloat', { bg = none })
  update_hl('FloatBoarded', { bg = none })
  update_hl('Folded', { bg = none })
  -- Number, CC, Cursor and Normal
  update_hl('LineNr', { bg = 'bg', fg = 'DarkGrey' })
  update_hl('CursorLine', { bg = none })
  update_hl('CursorLineNr', { bg = none, fg = '#ffffff' })
  update_hl('ColorColumn', { bg = '#111111' })
  update_hl('VertSplit', { fg = 'Grey' })
  -- IncSearch
  update_hl('IncSearch', { reverse = true })
  -- Pmenu
  update_hl('PmenuSel', { blend = none })
  -- Visual and Search
  update_hl('Visual', { bg = '#0e1f2f', fg = 'fg' })
  update_hl('Search', { reverse = true })
  -- Statusline
  update_hl('StatusLine', { bg = none, fg = '#ffffff' })
  update_hl('StatusLineModeNormal', { bg = none, fg = '#949494' })
  update_hl('StatusLineModeInsert', { bg = none, fg = '#57b0b2' })
  update_hl('StatusLineModeReplace', { bg = none, fg = '#ea6962' })
  update_hl('StatusLineModeVisual', { bg = none, fg = '#a9e861' })
  update_hl('StatusLineBranchMain', { bg = none, fg = '#2ef25d' })
  update_hl('StatusLineBranchOthers', { link = 'StatusLine' })
  -- Listchars
  update_hl('NonText', { fg = '#3a3a3a' })
  update_hl('Whitespace', { fg = '#3a3a3a' })
  -- mini.pick
  update_hl('MiniPickMatchCurrent', { link = 'PMenuSel' })
  update_hl('MiniPickPrompt', { link = 'MiniStarterItemPrefix' })
  update_hl('MiniPickBorder', { link = 'Normal' })
  -- mini.starter
  update_hl('MiniStarterItemPrefix', { link = 'ErrorMsg' })
  -- Diff
  update_hl('Added', { fg = '#b8cb26' })
  update_hl('Removed', { fg = '#f44747' })
  update_hl('Changed', { fg = '#599cd6' })
  -- Lsp
  update_hl('LspDiagnosticsDefaultError', { link = 'StatusLineModeReplace' })
  update_hl(
    'LspDiagnosticsVirtualTextError',
    { link = 'StatusLineModeReplace' }
  )
  update_hl('LspDiagnosticsSignError', { link = 'StatusLineModeReplace' })
  update_hl('LspDiagnosticsFloatingError', { link = 'StatusLineModeReplace' })
  update_hl('LspDiagnosticsFloatingHint', { bg = none })
  update_hl('LspDiagnosticsFloatingInformation', { bg = none })
  update_hl('LspDiagnosticsFloatingWarning', { bg = none })
  -- Man
  update_hl('manUnderline', { sp = 'fg', underline = true })
  -- Folded
  update_hl('Folded', { sp = '#636369' })
  -- Floating window borders
  update_hl('FloatBorder', { link = 'NonText' })
  -- Cmp
  update_hl('BlinkCmpMenu', { link = 'Normal' })
end

require('aug').add({ 'ColorScheme' }, {
  pattern = '*',
  callback = make_hls,
})

vim.cmd('colorscheme vscode')
