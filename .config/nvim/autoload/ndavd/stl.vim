scriptencoding utf-8

function! ndavd#stl#set() abort
endfunction

" --- Set statusline ----------------------------------------------------"

let s:nbsc=' '

function! s:stl() abort
  if s:make_stl()
    let stl =' %{%ndavd#stl#mode_hl()%}%-11{ndavd#stl#mode()}%*'
    let icon = luaeval("require'webdevicons_config'.get_icon"
          \ ."{do_hl={true,'StatusLine','StatusLineIcon'}}")
    let stl .= icon.'%f%{ndavd#stl#modified()}%<'.'%{%ndavd#stl#branch_hl()%}'
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

function! ndavd#stl#branch_hl() abort
  let branch = FugitiveHead(8)
  if branch=~#'master\|main'
    return '%#StatusLineBranchMain#'
  endif
    return '%#StatusLineBranchOthers#'
endfunction

function! ndavd#stl#branch() abort
  let branch = FugitiveHead(8)
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

function! ndavd#stl#mode_hl() abort
  let mode = mode()
  if match(['n','c'], mode)!=-1
    return '%#StatusLineModeNormal#'
  elseif match(['i','ix','s','S',"\<C-s>"], mode())!=-1
    return '%#StatusLineModeInsert#'
  elseif match(['R'], mode)!=-1
    return '%#StatusLineModeReplace#'
  elseif match(['v','V',"\<C-v>"], mode)!=-1
    return '%#StatusLineModeVisual#'
  endif
endfunction

function! ndavd#stl#mode() abort
  let mode = mode()
  let mode_map = {
        \ 'n': 'NORMAL  ', 'i': 'INSERT  ', 'R': 'REPLACE ',
        \ 'v': 'VISUAL  ', 'V': 'V·LINE  ', "\<C-v>": 'V·BLOCK ',
        \ 'c': 'COMMAND ', 's': 'SELECT  ', 'S': 'S·LINE  ',
        \ "\<C-s>": 'S·BLOCK '
        \ }
  let mode = get(mode_map, mode, '')
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
