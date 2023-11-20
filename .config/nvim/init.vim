"------------------------------------------------------------------------"
"|  ___  ________   ___  _________    ___      ___  ___   ______ _____  |"
"| |\  \|\   ___  \|\  \|\___   ___\ |\  \    /  /|/  /|/   _  / _   /| |"
"| \ \  \ \  \\ \  \ \  \|___ \  \_| \ \  \  /  / /  / /  / /__///  / / |"
"|  \ \  \ \  \\ \  \ \  \   \ \  \   \ \  \/  / /  / /  / |__|//  / /  |"
"|   \ \  \ \  \\ \  \ \  \   \ \  \ __\ \    / /  / /  / /    /  / /   |"
"|    \ \__\ \__\\ \__\ \__\   \ \__\\__\ \__/ /__/ /__/ /    /__/ /    |"
"|     \|__|\|__| \|__|\|__|    \|__\|__|\|__|/|__|/|__|/     |__|/     |"
"|       init.vim file (nvim 0.10.0) ----------------- by: ndavd        |"
"------------------------------------------------------------------------"
scriptencoding utf-8

" --- Load plugins ------------------------------------------------------"
lua require('plugins')

" -----------------------------------------------------------------------"
" --- NVIM settings -----------------------------------------------------"

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
set cursorline number relativenumber
set nohlsearch
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
set laststatus=3
set formatexpr=v:lua.require'conform_config'.formatexpr()'

" --- Title -------------------------------------------------------------"
set title
set titlestring=%t\ %m\ -\ NVIM

" --- Listchars ---------------------------------------------------------"
if &list
  let g:listchar_index = 0
  let g:listchar_options = [
        \ 'tab:_\ ,conceal:┊,nbsp:⍽,extends:>,precedes:<,trail:·'.
        \ ',eol:﬋',
        \ 'tab:_\ ,conceal:┊,nbsp:⍽,extends:>,precedes:<,trail:·',
        \ '',
        \ ]
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
let &fillchars='stl:-,stlnc:-'

" --- Change guicursor --------------------------------------------------"
set guicursor=i-r:hor20-Cursor

" --- Mouse options -----------------------------------------------------"
set mouse=a
set mousemodel=extend
set selection=inclusive

" --- Fix Highlight Errors ----------------------------------------------"
let g:vimsyn_noerror = 1

" --- Highlight when yanking --------------------------------------------"
aug LuaHighlight
  au!
  au TextYankPost *
        \ silent! lua require('vim.highlight').on_yank()
aug END

" --- Rasi highlighting (rofi theme file) -------------------------------"
aug RasiHighlight
  au BufNewFile,BufRead *.rasi set syntax=css
aug END

" --- Markdown ----------------------------------------------------------"
aug MarkdownHighlight
  au FileType markdown setlocal conceallevel=2
aug END

" -----------------------------------------------------------------------"
" --- Plugin settings ---------------------------------------------------"

" --- For WebDevicons ---------------------------------------------------"
" Load webdevicons config
lua require('webdevicons_config').my_setup()
" Update filetype icon highlight
lua require('webdevicons_config').make_hl()

" --- For Color picker --------------------------------------------------"
lua require('colorpicker_config')
nn <silent><C-c> <cmd>PickColor<CR>
ino <silent><C-c> <cmd>PickColorInsert<CR>

" --- For Colorizer -----------------------------------------------------"
nn <silent><leader>co :ColorizerToggle<CR>

" --- For Hop.nvim ------------------------------------------------------"
no <silent>,w <cmd>HopWord<CR>
no <silent>,q <cmd>HopChar2<CR>

" " --- For ScrollView ----------------------------------------------------"
" let g:scrollview_on_startup = 0
" let g:scrollview_column = 1
" let g:scrollview_excluded_filetypes =
"       \ ['startify', 'vista_kind', 'packer']
" let g:scrollview_mode = 'flexible'
" let g:active_scrollview = 0
" function ToggleSrollView()
"   if g:active_scrollview == 0
"     let g:active_scrollview = 1
"     exe 'ScrollViewEnable'
"   elseif g:active_scrollview == 1
"     let g:active_scrollview = 0
"     exe 'ScrollViewDisable'
"   endif
" endfunction
" nn <silent><leader>sb :call ToggleSrollView()<CR>

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
  let g:startify_custom_header += startify#pad(s:ascii_darth_vader)
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
" nn <silent><leader><leader>s :call StartifyReLaunch()<CR>

" --- For Symbols-outline.nvim ------------------------------------------"
lua require('symbolsoutline_config')
nn <silent><C-s> :SymbolsOutline<CR>

" --- For signify -------------------------------------------------------"
let s:signify_symbol      = '▌' " ▊
let g:signify_sign_add    = s:signify_symbol
let g:signify_sign_change = s:signify_symbol
let g:signify_sign_delete = s:signify_symbol

" --- For comment.nvim --------------------------------------------------"
lua require('comment_config')

" --- For tree-tree.nvim ------------------------------------------------"
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
lua require('nvim_tree_config')

" --- For matchup -------------------------------------------------------"
let g:matchup_matchparen_offscreen = {}

" --- For vim-easy-align ------------------------------------------------"
xmap <cr> <plug>(LiveEasyAlign)

" --- For vim-sleuth ----------------------------------------------------"
let g:sleuth_automatic = 0
nn <leader><leader>s :Sleuth<CR>

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
nn z= :lua require('telescope_config').spell_suggest()<CR>
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
nn <silent><C-n> :lua vim.diagnostic.goto_next{popup=false}<CR>
nn <silent><C-p> :lua vim.diagnostic.goto_prev{popup=false}<CR>
nn <silent>gk    :lua vim.lsp.buf.hover()<CR>
nn <silent>gd    :lua require('lsp_custom').definition()<CR>
nn <silent>gD    :lua vim.lsp.buf.declaration()<CR>
nn <silent>gr    :lua vim.lsp.buf.rename()<CR>
nn <silent>gR    :lua vim.lsp.buf.references()<CR>
nn <silent>gh    :lua vim.lsp.buf.inlay_hint(0)<CR>
" Commands
com Cd lua require('lsp_custom').cd_project_root()

" --- For vim-vsnip -----------------------------------------------------"
imap <expr><C-k> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-k>'
smap <expr><C-k> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-k>'
imap <expr><C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'
smap <expr><C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'

" --- For cmp -----------------------------------------------------------"
lua require('cmp_config')

" --- For conform.nvim --------------------------------------------------"
lua require('conform_config')

" --- For nvim-lint -----------------------------------------------------"
lua require('lint_config')

" -----------------------------------------------------------------------"
" --- Custom lua settings -----------------------------------------------"

lua require('custom')

" -----------------------------------------------------------------------"
finish
Impulse. Response. Fluid. Imperfect. Patterned. Chaotic.
