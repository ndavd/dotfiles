"------------------------------------------------------------------------"
"|  ___  ________   ___  _________    ___      ___  ___   ______ _____  |"
"| |\  \|\   ___  \|\  \|\___   ___\ |\  \    /  /|/  /|/   _  / _   /| |"
"| \ \  \ \  \\ \  \ \  \|___ \  \_| \ \  \  /  / /  / /  / /__///  / / |"
"|  \ \  \ \  \\ \  \ \  \   \ \  \   \ \  \/  / /  / /  / |__|//  / /  |"
"|   \ \  \ \  \\ \  \ \  \   \ \  \ __\ \    / /  / /  / /    /  / /   |"
"|    \ \__\ \__\\ \__\ \__\   \ \__\\__\ \__/ /__/ /__/ /    /__/ /    |"
"|     \|__|\|__| \|__|\|__|    \|__\|__|\|__|/|__|/|__|/     |__|/     |"
"|       init.vim file (nvim 0.7.0) ------------------ by: ndavid       |"
"------------------------------------------------------------------------"

" --- Load plugins ------------------------------------------------------"
lua require('plugins')

" -----------------------------------------------------------------------"
" ---------------- NVIM SETTINGS ----------------------------------------"
" -----------------------------------------------------------------------"
" --- Define mapleader for keymaps --------------------------------------"
let mapleader = ' '

" --- Check if it's a console -------------------------------------------"
if $TERM =~ 'linux\|screen' | let g:isConsole = v:true
else | let g:isConsole = v:false | endif

" --- Enable 256 color support ------------------------------------------"
if !g:isConsole | set termguicolors | endif

" --- Disable recommended styles ----------------------------------------"
" Be a round peg in a square hole
let g:python_recommended_style = 0
let g:rust_recommended_style = 0

" --- Global settings ---------------------------------------------------"
set nowrap
set clipboard=unnamedplus
set noshowmode
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set cul nu rnu
set nohls
set list
set ignorecase
set smartcase
set noswapfile
set nobackup
set undofile
set pumblend=15
set textwidth=80
" set colorcolumn=+1
set updatetime=100
set completeopt=menuone,noselect
set shortmess+=c
set inccommand=split
set foldmethod=marker

" --- Title -------------------------------------------------------------"
set title
set titlestring=%t\ %m\ -\ NVIM

" --- Listchars ---------------------------------------------------------"
if &list && !g:isConsole
  let g:listchar_index = 0
  let g:listchar_options = [
        \ 'tab:>\ ,conceal:┊,nbsp:⍽,extends:>,precedes:<,trail:·'.
        \ ',eol:﬋',
        \ 'tab:>\ ,conceal:┊,nbsp:⍽,extends:>,precedes:<,trail:·',
        \ '',
        \ ]
  " Nice chars ﲒ ﮊ ⌴ ⍽   ▷▻⊳►▶▚‽⊛ψψδ…﬋↲↵┊
  " ﴣ             ➜
  function CycleListchars() abort
    exe 'set listchars='.g:listchar_options[
          \ float2nr(
          \ fmod(g:listchar_index, len(g:listchar_options))
          \ )]
    let g:listchar_index += 1
  endfunction
  " Cycle listchars
  nn <silent><leader><leader>cl :call CycleListchars()<CR>
  call CycleListchars()
endif

" --- Fillchars ---------------------------------------------------------"
let &fcs='stl:-,stlnc:-'

" --- Change guicursor --------------------------------------------------"
set guicursor=i-r:hor20-Cursor

" --- Mouse options -----------------------------------------------------"
set mouse=a
behave xterm

" --- Fix Highlight Errors ----------------------------------------------"
let g:vimsyn_noerror = 1

" --- Highlight when yanking --------------------------------------------"
aug LuaHighlight
  au!
  au TextYankPost *
        \ silent! lua require('vim.highlight').on_yank({on_visual=false})
aug END

" --- Rasi highlighting (rofi theme file) -------------------------------"
au BufNewFile,BufRead *.rasi set syntax=css

" --- Stick figures (🯅🯆🯇🯈🯉) ---------------------------------------------"
let g:runner = ["🯆", "🯇", "🯅", "🯈"]
function PrintRunner(msg)
  let msg_l = len(a:msg)
  let pad_right = 13
  let n = 0
  let forwards = v:true
  while 1
    if n == &columns-msg_l-pad_right
      let forwards = v:false
    elseif n == 0
      let forwards = v:true
    endif
    echo repeat(forwards?".":" ", n)
          \. g:runner[n % len(g:runner)]
          \. repeat(forwards?" ":".", &columns-n-msg_l-pad_right)
          \. a:msg
    let n = forwards?n+1:n-1
    sleep 200m
    redraw
    if getchar(1) != 0
      break
    endif
  endwhile
endfunction
function StartRunner(timer)
  echo PrintRunner("fixing your code")
endfunction
" au CursorHold * let s:timer = timer_start(300000, 'StartRunner')
" au CursorMoved,WinLeave,ModeChanged * if has_key(s:, 'timer')
"       \| call timer_stop(s:timer)
"       \| unlet s:timer
"       \| echo ""
"       \| endif

" -----------------------------------------------------------------------"
" ---------------- PLUGIN SETTINGS --------------------------------------"
" -----------------------------------------------------------------------"
" --- For WebDevicons ---------------------------------------------------"
if !g:isConsole
  " Load webdevicons config
  lua require('webdevicons_config').my_setup()
  " Update filetype icon highlight
  lua require('webdevicons_config').make_hl()
endif

" --- For Colorizer -----------------------------------------------------"
nn <silent><leader>co :ColorizerToggle<CR>

" --- For Hop.nvim ------------------------------------------------------"
no <silent>,w <cmd>HopWord<CR>
no <silent>,q <cmd>HopChar2<CR>

" --- For ScrollView ----------------------------------------------------"
let g:scrollview_on_startup = 0
let g:scrollview_column = 1
let g:scrollview_excluded_filetypes =
      \ ['startify', 'vista_kind', 'packer']
let g:scrollview_mode = 'flexible'
let g:active_scrollview = 0
function ToggleSrollView()
  if g:active_scrollview == 0
    let g:active_scrollview = 1
    exe 'ScrollViewEnable'
  elseif g:active_scrollview == 1
    let g:active_scrollview = 0
    exe 'ScrollViewDisable'
  endif
endfunction
nn <silent><leader>sb :call ToggleSrollView()<CR>

" --- For vim-smoothie --------------------------------------------------"
let g:smoothie_no_default_mappings = 1
" Keymaps
nn <silent><A-k> :call smoothie#upwards()<CR>
nn <silent><A-j> :call smoothie#downwards()<CR>

" --- For vim-startify --------------------------------------------------"
function! StartifyEntryFormat()
  if g:isConsole | return "entry_path" | endif
  return "luaeval(\"require'webdevicons_config'.get_icon{"
        \."filepath=_A}\", absolute_path)"
        \." .\" \". entry_path"
endfunction
function GetNvimVersion()
  redir => s
  silent! version
  redir END
  return 'NVIM v'.matchstr(s, 'NVIM v\zs[^\n]*')
endfunction
let g:startify_skiplist = [ '/misc/', '/notes/' ]
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
let g:startify_bookmarks = [
      \ ]
let g:startify_commands = [
      \ {'p': 'PackerSync'},
      \ ]
let g:startify_files_number = 5
let g:startify_fortune_use_unicode = 0
let g:startify_enable_special = 0
let g:startify_padding_left = 2
let g:startify_custom_header_quotes =
      \ startify#fortune#predefined_quotes() +
      \ [[
      \ 'The career of a young theoretical physicist consists'.
      \ ' of treating the harmonic oscillator in ever-increasing'.
      \ ' levels of abstraction.','','- Sidney Coleman'
      \ ]]
let s:ascii_darth_vader = [
      \ '     o       ⌌━━━ ⌍      ',
      \ '      o     | //   ░▏    ',
      \ '       o  _/,-||-_╲_\    ',
      \ '          / (■)(■)\\░\   ',
      \ '         / \_/_\__/\  ╲  ',
      \ '        (   ╱╱ii\\/ )  \_',
      \ '         ╲▁  ▔▔▔▔─⌍▁▁▁▁▁/',
      \ '          ▁▁▐ ▐  ▐ \     ',
      \ ]
function StartifyUpdateQuote()
  let s:get_quote = startify#fortune#boxed()
endfunction
function StartifyUpdateCentering()
  let g:startify_custom_header =
        \ startify#pad([GetNvimVersion()]) +
        \ startify#pad(['',
        \ 'Welcome to the Dark Side of text editing',
        \ 'Nvim is open source and freely distributable',
        \ '']) + startify#pad(s:get_quote)
  if !g:isConsole
    let g:startify_custom_header += startify#pad(s:ascii_darth_vader)
  endif
endfunction
au VimEnter * call StartifyUpdateQuote()
      \| call StartifyUpdateCentering()
au VimResized * if &ft=='startify' && winwidth(0)>=64
      \| call StartifyUpdateCentering()
      \| call startify#insane_in_the_membrane(0)
      \| endif
function StartifyReLaunch()
  call StartifyUpdateQuote()
  call StartifyUpdateCentering()
  Startify
endfunction
nn <silent><leader><leader>s :call StartifyReLaunch()<CR>

" --- For Vista.vim -----------------------------------------------------"
let g:vista_default_executive = 'nvim_lsp'
let g:vista_icon_indent = ["└─ ", "├─ "]
au VimResized * let g:vista_sidebar_width =
      \ string(nvim_win_get_width(0)*0.3)
let g:vista_update_on_text_changed = 1
let g:vista_cursor_delay = 10
if exists('g:scrollview_on_startup')
  nn <silent><leader>v :Vista!!<CR>:ScrollViewRefresh<CR>
else
  nn <silent><leader>v :Vista!!<CR>
endif

" --- For signify -------------------------------------------------------"
let s:signify_symbol      = '▌' " ▊
let g:signify_sign_add    = s:signify_symbol
let g:signify_sign_change = s:signify_symbol
let g:signify_sign_delete = s:signify_symbol

" --- For Luapad --------------------------------------------------------"
lua require('luapad_config')

" --- For comment.nvim --------------------------------------------------"
lua require('comment_config')

" --- For indent-blankline ----------------------------------------------"
lua require('indentblankline_config')
nn <silent><leader>i :IndentBlanklineToggle<CR>

" --- For matchup -------------------------------------------------------"
let g:matchup_matchparen_offscreen = {}

" --- For vim-easy-align ------------------------------------------------"
xmap <cr> <plug>(LiveEasyAlign)

" --- For zk-nvim -------------------------------------------------------"
lua require('zk_config')
autocmd Filetype markdown syn region markdownWikiLink
      \ matchgroup=markdownLinkDelimiter
      \ start="\[\[" end="\]\]"
      \ contains=markdownUrl
      \ keepend oneline concealends

" --- For vim-sleuth ----------------------------------------------------"
let g:sleuth_automatic = 0

" --- For nvim-treesitter -----------------------------------------------"
lua require('treesitter_config')

" --- For nvim-telescope ------------------------------------------------"
" Load config file
lua require('telescope_config')
" Keymaps
nn ,, :lua require('telescope.builtin').find_files()<CR>
nn ,f :lua require('telescope').extensions.frecency.frecency()<CR>
nn ,g :lua require('telescope.builtin').live_grep()<CR>
nn ,s :lua require('telescope.builtin').grep_string()<CR>
nn ,a :lua require('telescope.builtin').lsp_code_actions()<CR>
nn ,h :lua require('telescope.builtin').help_tags()<CR>
nn ,c :lua require('telescope_config').search_config()<CR>
nn ,t :lua require('telescope.builtin').treesitter()<CR>
nn z= :lua require('telescope.builtin').spell_suggest()<CR>
nn <leader>gb :lua require('telescope_config').git_branches()<CR>

" --- For lsp -----------------------------------------------------------"
" Load config file
lua require('lspconfig_config')
" Lsp formatting
nn <silent><leader><leader>f :lua vim.lsp.buf.formatting()<CR>
" Change signs
let s:lsp_signs=['DiagnosticSignError', 'DiagnosticSignWarn',
      \ 'DiagnosticSignInfo', 'DiagnosticSignHint']
for i in s:lsp_signs
  exe 'sign define '.i.' text= texthl= linehl= numhl='.i
endfor
" Keymaps
nn <silent><C-n> :lua vim.diagnostic.goto_next{enable_popup=false}<CR>
nn <silent><C-p> :lua vim.diagnostic.goto_prev{enable_popup=false}<CR>
nn <silent>gk    :lua vim.lsp.buf.hover()<CR>
nn <silent>gd    :lua vim.lsp.buf.definition()<CR>
nn <silent>gD    :lua vim.lsp.buf.declaration()<CR>
nn <silent>gr    :lua vim.lsp.buf.rename()<CR>
nn <silent>gR    :lua vim.lsp.buf.references()<CR>

" --- For vim-vsnip -----------------------------------------------------"
imap <expr><C-k> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-k>'
smap <expr><C-k> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-k>'
imap <expr><C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'
smap <expr><C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'

" --- For cmp -----------------------------------------------------------"
lua require'cmp_config'

" -----------------------------------------------------------------------"
finish
Impulse. Response. Fluid. Imperfect. Patterned. Chaotic.
