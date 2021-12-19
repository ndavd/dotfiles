function ndavid#colors#set()
endfunction

" --- Highlights --------------------------------------------------------"

function s:make_hls() abort
  " Transparent background color for Nvim
  hi Normal guibg=NONE
  hi NonText guibg=NONE
  hi ModeMsg guibg=NONE
  hi MoreMsg guibg=NONE
  hi ModeArea guibg=NONE
  hi ErrorMsg guibg=NONE
  hi Error guibg=NONE
  hi Directory guibg=NONE
  hi VertSplit guibg=NONE
  hi SignColumn guibg=NONE
  hi EndOfBuffer guibg=NONE guifg=#5a5a5a
  hi NormalFloat guibg=NONE
  hi Folded guibg=NONE
  " Number, CC, Cursor and Normal
  hi LineNr guibg=bg guifg=darkgrey
  hi CursorLine guibg=NONE
  hi CursorLineNr guibg=bg guifg=white
  hi ColorColumn ctermbg=darkgrey guibg=#111111
  hi Cursor ctermbg=white guibg=white
  hi VertSplit guifg=grey
  " IncSearch
  hi IncSearch gui=reverse
  " Pmenu
  hi PmenuSel blend=0
  " Visual and Search
  hi Visual gui=NONE guibg=#0E1F2F guifg=fg
  hi Search gui=reverse
  " Startify
  hi StartifyHeader gui=NONE guifg=#d4d4d4
  hi StartifyFooter gui=NONE guifg=#d4d4d4
  " Signify
  hi SignifySignAdd guifg=#b8cb26 guibg=NONE
  hi SignifySignDelete guifg=#f44747 guibg=NONE
  hi SignifySignChange guifg=#599cd6 guibg=NONE
  " Statusline
  hi StatusLine gui=NONE guibg=NONE guifg=#ffffff
  hi StatusLineNC gui=NONE guibg=NONE guifg=#444444
  " Listchars
  hi NonText guifg=#3a3a3a
  hi Whitespace guifg=#3a3a3a
  " Indent Blankline
  hi IndentBlankline1 guibg=#101010
  hi IndentBlankline2 guibg=NONE
  " Match
  hi MatchWord gui=underline guisp=#bbbbbb
  hi MatchWordCur gui=underline guisp=#bbbbbb
  " Packer
  hi packerWorking guibg=NONE guifg=#599cd6 gui=NONE
  hi packerSuccess guibg=NONE guifg=#b8cb26 gui=bold
  hi packerFail guibg=NONE guifg=#f44747 gui=bold
  " ScrollView
  hi ScrollView guibg=#ffffff
  " Telescope
  hi! link TelescopePromptBorder Normal
  hi! link TelescopePreviewBorder Normal
  hi! link TelescopeResultsBorder Normal
  hi TelescopePromptPrefix guifg=#ea6962
  " Lsp
  hi LspDiagnosticsDefaultError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsVirtualTextError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsSignError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsFloatingError guibg=NONE guifg=#ea6962
  hi LspDiagnosticsFloatingHint guibg=NONE
  hi LspDiagnosticsFloatingInformation guibg=NONE
  hi LspDiagnosticsFloatingWarning guibg=NONE
  " Compe
  hi CompeDocumentation guibg=#222222
  " Nvim Tree
  hi NvimTreeNormal guibg=NONE
  " Man
  hi manUnderline guisp=fg gui=underline
  " Folded
  hi Folded guisp=#636369
endfunction
aug make_custom_hls
  au!
  au ColorScheme * call s:make_hls()
aug END

" For vscode
function s:custom_vscode_hls()
  " MatchParen
  hi MatchParen guibg=#303030
  " " Tabline
  " hi TabLine guifg=#6b9956 guibg=#111111
  " hi TabLineSel guifg=#111111 guibg=#6b9956
  " hi TabLineFill guifg=#949494 guibg=NONE
endfunction
aug VscodeCustom
  au!
  au ColorScheme vscode call s:custom_vscode_hls()
aug END

" --- Set colorscheme ---------------------------------------------------"

set background=dark
let g:vscode_style="dark"
colorscheme vscode
