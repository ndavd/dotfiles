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
aug HighlightOnYank
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

" --- Load plugins ------------------------------------------------------"
lua require('plugins')

" --- Custom lua settings -----------------------------------------------"
lua require('custom')

" -----------------------------------------------------------------------"
finish
Impulse. Response. Fluid. Imperfect. Patterned. Chaotic.
