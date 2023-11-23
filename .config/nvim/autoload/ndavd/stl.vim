scriptencoding utf-8

function! ndavd#stl#set() abort
endfunction

" --- Set statusline ----------------------------------------------------"

" Load webdevicons config
lua require('webdevicons_config').my_setup()

let s:bg='NONE'
let s:nbsc=' '

function! s:stl() abort
  if s:make_stl()
    let stl =' %#StatusLineMode#%-11{ndavd#stl#mode()}%*'
    let icon = luaeval("require'webdevicons_config'.get_icon"
          \ ."{do_hl={true,'StatusLine','StatusLineIcon'}}")
    let stl .= icon.'%f%{ndavd#stl#modified()}%<'.'%#StatusLineBranch#'
          \ .'%{ndavd#stl#branch()}%*%{ndavd#stl#sy_stats_wrapper()} '
    if s:show_ln==1 | let stl .= '%= %l(%02p%%):%-1c' | endif
    let &l:stl = stl
  endif
endfunction

function! ndavd#stl#modified() abort
  if &modifiable
    if &modified
      return '[+]'
    else | return '' | endif
  else | return '[-]' | endif
endfunction

function! ndavd#stl#branch() abort
  let branch = FugitiveHead(8)
  if branch=~#'master\|main'
    exe 'hi StatusLineBranch guifg=#2ef25d ctermfg=Green guibg='.s:bg.' ctermbg='.s:bg
  else | exe 'hi! link StatusLineBranch StatusLine' | endif
  return branch ==# '' ? '' : s:nbsc.'['.branch.']'
endfunction

function! s:make_stl() abort
  return &filetype!~#'starter\|lazy\|pick'
endfunction

function! ndavd#stl#sy_stats_wrapper() abort
  let [added, modified, removed] = sy#repo#get_stats()
  let symbols = ['+', '-', '~']
  let stats = [added, removed, modified]  " reorder
  let statline = ''
  for i in range(3)
    if stats[i] > 0
      let statline .= printf('%s%s,', symbols[i], stats[i],)
    endif
  endfor
  if !empty(statline)
    let statline = printf('[%s]', statline[:-2])
  endif
  return statline
endfunction

function! ndavd#stl#mode() abort
  let mode = mode()
  if match(['n','c'], mode)!=-1
    let guifg='#949494'
    let ctermfg='DarkGrey'
  elseif match(['i','ix','s','S',"\<C-s>"], mode())!=-1
    let guifg='#57b0b2'
    let ctermfg='LightBlue'
  elseif match(['R'], mode)!=-1
    let guifg='#ea6962'
    let ctermfg='Red'
  elseif match(['v','V',"\<C-v>"], mode)!=-1
    let guifg='#a9e861'
    let ctermfg='Green'
  endif
  let mode_map = {
        \ 'n': 'NORMAL  ', 'i': 'INSERT  ', 'R': 'REPLACE ',
        \ 'v': 'VISUAL  ', 'V': 'V·LINE  ', "\<C-v>": 'V·BLOCK ',
        \ 'c': 'COMMAND ', 's': 'SELECT  ', 'S': 'S·LINE  ',
        \ "\<C-s>": 'S·BLOCK '
        \ }
  let mode = get(mode_map, mode, '')
  if mode=~#'NORMAL\|COMMAND'
    exe 'hi StatusLineMode guifg='.guifg.' gui=NONE cterm=NONE ctermfg='.ctermfg
  else
    exe 'hi StatusLineMode guifg='.guifg.' gui=bold cterm=bold ctermfg='.ctermfg
  endif
  if mode==#'INSERT' | let mode = 'ʌʌ'.s:nbsc.mode
  elseif mode==#'REPLACE' | let mode = 'vv'.s:nbsc.mode
  else | let mode = '>>'.s:nbsc.mode | endif
  return mode
endfunction

" Show line info
let s:show_ln = 0
function! ndavd#stl#toggle_ln() abort
  if s:show_ln == 0
    let s:show_ln=1
    call s:stl()
  else
    let s:show_ln=0
    call s:stl()
  endif
endfunction
nn <silent><expr><leader>sl ndavd#stl#toggle_ln()

aug NdavdStl
  " Update Statusline when entering
  au BufEnter * call s:stl()

  au User MiniPickStart let &l:stl='%= 🔭 Pick %='
  " Lazy statusline
  au FileType lazy let &l:stl='%=  Lazy %='
  " mini.starter statusline
  au User MiniStarterOpened let &l:stl='%=  mini.starter %='
  " Terminal statusline
  au TermOpen * let &l:stl='%=  terminal %='
aug END
