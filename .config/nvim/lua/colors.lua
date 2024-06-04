local make_hls = function()
  vim.cmd([[
  hi Comment ctermfg=DarkBlue
  " Transparent background color for Nvim
  hi Normal guibg=NONE
  hi NonText guibg=NONE
  hi ModeMsg guibg=NONE
  hi MoreMsg guibg=NONE
  hi ModeArea guibg=NONE
  hi ErrorMsg guibg=NONE
  hi Error guibg=NONE
  hi Directory guibg=NONE
  hi VertSplit guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE
  hi EndOfBuffer guibg=NONE guifg=#5a5a5a
  hi NormalFloat guibg=NONE
  hi FloatBoarded guibg=NONE
  hi Folded guibg=NONE
  " Number, CC, Cursor and Normal
  hi LineNr guibg=bg guifg=DarkGrey ctermbg=NONE ctermfg=DarkGrey
  hi CursorLine guibg=NONE ctermbg=NONE cterm=NONE
  hi CursorLineNr guibg=bg guifg=White cterm=NONE ctermbg=NONE ctermfg=White
  hi ColorColumn guibg=#111111 ctermbg=DarkGrey
  hi VertSplit guifg=Grey cterm=NONE ctermfg=Grey
  " IncSearch
  hi IncSearch gui=reverse
  " Pmenu
  hi PmenuSel blend=0
  " Visual and Search
  hi Visual gui=NONE guibg=#0E1F2F guifg=fg ctermbg=DarkBlue ctermfg=White
  hi Search gui=reverse cterm=reverse
  " Statusline
  hi StatusLine gui=NONE guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=White
  hi StatusLineModeNormal gui=NONE guibg=NONE ctermbg=NONE guifg=#949494 ctermfg=DarkGrey
  hi StatusLineModeInsert gui=NONE guibg=NONE ctermbg=NONE guifg=#57b0b2 ctermfg=LightBlue
  hi StatusLineModeReplace gui=NONE guibg=NONE ctermbg=NONE guifg=#ea6962 ctermfg=Red
  hi StatusLineModeVisual gui=NONE guibg=NONE ctermbg=NONE guifg=#a9e861 ctermfg=Green
  hi StatusLineBranchMain gui=NONE guibg=NONE ctermbg=NONE guifg=#2ef25d ctermfg=Green
  hi! link StatusLineBranchOthers StatusLine
  " Listchars
  hi NonText guifg=#3a3a3a
  hi Whitespace guifg=#3a3a3a
  " Match
  hi MatchWord gui=underline guisp=#bbbbbb ctermbg=DarkRed
  hi MatchWordCur gui=underline guisp=#bbbbbb ctermbg=DarkRed
  " mini.pick
  hi! link MiniPickMatchCurrent PMenuSel
  hi! link MiniPickPrompt MiniStarterItemPrefix
  hi! link MiniPickBorder Normal
  " Diff
  hi Added guifg=#b8cb26 ctermfg=DarkGreen
  hi Removed guifg=#f44747 ctermfg=DarkRed
  hi Changed guifg=#599cd6 ctermfg=DarkBlue
  " Lsp
  hi LspDiagnosticsDefaultError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsVirtualTextError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsSignError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsFloatingError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsFloatingHint guibg=NONE
  hi LspDiagnosticsFloatingInformation guibg=NONE
  hi LspDiagnosticsFloatingWarning guibg=NONE
  " Man
  hi manUnderline guisp=fg gui=underline
  " Folded
  hi Folded guisp=#636369
  ]])
end

local make_vscode_hls = function()
  vim.cmd([[
  " MatchParen
  hi MatchParen guibg=#303030
  ]])
end

local aug = require('aug')

aug.add({ 'ColorScheme' }, {
  pattern = '*',
  callback = make_hls,
})

aug.add({ 'ColorScheme' }, {
  pattern = 'vscode',
  callback = make_vscode_hls,
})

vim.o.background = 'dark'
require('plugins.vscode_colors')

vim.cmd('colorscheme vscode')
