"------------------------------------------------------------------------"
"|  ___  ________   ___  _________    ___      ___  ___   ______ _____  |"
"| |\  \|\   ___  \|\  \|\___   ___\ |\  \    /  /|/  /|/   _  / _   /| |"
"| \ \  \ \  \\ \  \ \  \|___ \  \_| \ \  \  /  / /  / /  / /__///  / / |"
"|  \ \  \ \  \\ \  \ \  \   \ \  \   \ \  \/  / /  / /  / |__|//  / /  |"
"|   \ \  \ \  \\ \  \ \  \   \ \  \ __\ \    / /  / /  / /    /  / /   |"
"|    \ \__\ \__\\ \__\ \__\   \ \__\\__\ \__/ /__/ /__/ /    /__/ /    |"
"|     \|__|\|__| \|__|\|__|    \|__\|__|\|__|/|__|/|__|/     |__|/     |"
"|       init.vim file (nvim 0.6.0) ------------------ by: ndavid       |"
"------------------------------------------------------------------------"

" --- Load plugins ------------------------------------------------------"
lua require('plugins')

" -----------------------------------------------------------------------"
" ---------------- NVIM SETTINGS ----------------------------------------"
" -----------------------------------------------------------------------"
" --- Define mapleader for keymaps --------------------------------------"
let mapleader = ' '

" --- Enable 256 color support ------------------------------------------"
set termguicolors

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
if &list && $TERM!="linux"
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
    execute 'set listchars='.g:listchar_options[
          \ float2nr(
          \ fmod(g:listchar_index, len(g:listchar_options))
          \ )]
    let g:listchar_index += 1
  endfunction
  " Cycle listchars
  nnoremap <silent><leader><leader>cl :call CycleListchars()<CR>
  call CycleListchars()
endif

" --- Fillchars ---------------------------------------------------------"
let &fcs='stl:-,stlnc:-'

" --- Change guicursor --------------------------------------------------"
set guicursor=a:block-Cursor,i-r:hor20-Cursor

" --- Mouse options -----------------------------------------------------"
set mouse=a
behave xterm

" --- Fix Highlight Errors ----------------------------------------------"
let g:vimsyn_noerror = 1

" --- Highlight when yanking --------------------------------------------"
augroup LuaHighlight
  au!
  au TextYankPost *
        \ silent! lua require('vim.highlight').on_yank({on_visual=false})
augroup END

" --- Rasi highlighting (rofi theme file) -------------------------------"
au BufNewFile,BufRead *.rasi set syntax=css

" -----------------------------------------------------------------------"
" ---------------- PLUGIN SETTINGS --------------------------------------"
" -----------------------------------------------------------------------"
" --- For WebDevicons ---------------------------------------------------"
" Load webdevicons config
lua require('webdevicons_config').my_setup()
" Update filetype icon highlight
lua require('webdevicons_config').make_hl()

" --- For Colorizer -----------------------------------------------------"
nnoremap <silent><leader>co :ColorizerToggle<CR>

" --- For Hop.nvim ------------------------------------------------------"
noremap <silent>,w <cmd>HopWord<CR>
noremap <silent>,q <cmd>HopChar2<CR>

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
    execute 'ScrollViewEnable'
  elseif g:active_scrollview == 1
    let g:active_scrollview = 0
    execute 'ScrollViewDisable'
  endif
endfunction
nnoremap <silent><leader>sb :call ToggleSrollView()<CR>

" --- For vim-smoothie --------------------------------------------------"
let g:smoothie_no_default_mappings = 1
" Keymaps
nnoremap <silent><A-k> :call smoothie#upwards()<CR>
nnoremap <silent><A-j> :call smoothie#downwards()<CR>

" --- For vim-startify --------------------------------------------------"
function! StartifyEntryFormat()
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
let g:startify_skiplist = [ '/misc/' ]
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
        \ '']) + startify#pad(s:get_quote) +
        \ startify#pad(s:ascii_darth_vader)
endfunction
autocmd VimEnter * call StartifyUpdateQuote()
      \| call StartifyUpdateCentering()
autocmd VimResized * if &ft=='startify' && winwidth(0)>=64
      \| call StartifyUpdateCentering()
      \| call startify#insane_in_the_membrane(0)
      \| endif
function StartifyReLaunch()
  call StartifyUpdateQuote()
  call StartifyUpdateCentering()
  Startify
endfunction
nnoremap <silent><leader><leader>s :call StartifyReLaunch()<CR>

" --- For Vista.vim -----------------------------------------------------"
let g:vista_default_executive = 'nvim_lsp'
let g:vista_icon_indent = ["└─ ", "├─ "]
autocmd VimResized * let g:vista_sidebar_width =
      \ string(nvim_win_get_width(0)*0.3)
let g:vista_update_on_text_changed = 1
let g:vista_cursor_delay = 10
if exists('g:scrollview_on_startup')
  nnoremap <silent><leader>v :Vista!!<CR>:ScrollViewRefresh<CR>
else
  nnoremap <silent><leader>v :Vista!!<CR>
endif

" --- For signify -------------------------------------------------------"
let s:signify_symbol      = '▌' " ▊
let g:signify_sign_add    = s:signify_symbol
let g:signify_sign_change = s:signify_symbol
let g:signify_sign_delete = s:signify_symbol

" --- For Luapad --------------------------------------------------------"
lua require('luapad_config')

" --- For commentary.nvim -----------------------------------------------"
lua require('Comment').setup()

" --- For indent-blankline ----------------------------------------------"
lua require('indentblankline_config')
nnoremap <silent><leader>i :IndentBlanklineToggle<CR>

" --- For matchup -------------------------------------------------------"
let g:matchup_matchparen_offscreen = {}

" --- For vim-easy-align ------------------------------------------------"
xmap <cr> <plug>(LiveEasyAlign)

" --- For creating presentations in vim ---------------------------------"
autocmd BufNewFile,BufRead *.vpm call SetVimPresentationMode()
function SetVimPresentationMode()
  set laststatus=0
  hi NonText guifg=bg ctermfg=bg
  set nonu
  nnoremap <buffer> <Right> :n<CR>
  nnoremap <buffer> <Left> :N<CR>
endfunction

" --- For vim-sleuth ----------------------------------------------------"
let g:sleuth_automatic = 0

" --- For nvim-treesitter -----------------------------------------------"
lua require('treesitter_config')

" --- For sql.nvim ------------------------------------------------------"
" let g:sql_clib_path = '/usr/bin/lib/sqlite3.so'

" --- For nvim-telescope ------------------------------------------------"
" Load config file
lua require('telescope_config')
" Keymaps
nnoremap ,,         :lua require('telescope.builtin').find_files()<CR>
nnoremap ,f         :lua require('telescope').extensions.frecency.frecency()<CR>
nnoremap ,g         :lua require('telescope.builtin').live_grep()<CR>
nnoremap ,s         :lua require('telescope.builtin').grep_string()<CR>
nnoremap ,a         :lua require('telescope.builtin').lsp_code_actions()<CR>
nnoremap ,h         :lua require('telescope.builtin').help_tags()<CR>
nnoremap ,c         :lua require('telescope_config').search_config()<CR>
nnoremap <leader>gt :lua require('telescope.builtin').treesitter()<CR>
nnoremap <leader>gb :lua require('telescope_config').git_branches()<CR>
nnoremap z=         :lua require('telescope.builtin').spell_suggest()<CR>

" --- For lsp -----------------------------------------------------------"
" Load config file
lua require('lspconfig_config')
" Lsp formatting
nnoremap <silent><leader><leader>f :lua vim.lsp.buf.formatting()<CR>
" Change signs
let s:lsp_signs=['DiagnosticSignError', 'DiagnosticSignWarn',
      \ 'DiagnosticSignInfo', 'DiagnosticSignHint']
for i in s:lsp_signs
  execute 'sign define '.i.' text= texthl= linehl= numhl='.i
endfor
" Keymaps
nnoremap <silent><C-n> :lua vim.lsp.diagnostic.goto_next{enable_popup=false}<CR>
nnoremap <silent><C-p> :lua vim.lsp.diagnostic.goto_prev{enable_popup=false}<CR>
nnoremap <silent>gi    :lua vim.lsp.diagnostic.show_line_diagnostics(
      \ {show_header = false, border = "single"})<CR>
nnoremap <silent>gk    :lua vim.lsp.buf.hover()<CR>
nnoremap <silent>gd    :lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD    :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent>gr    :lua vim.lsp.buf.rename()<CR>
nnoremap <silent>gR    :lua vim.lsp.buf.references()<CR>

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
