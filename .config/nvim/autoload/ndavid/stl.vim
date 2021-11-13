function ndavid#stl#set()
endfunction

" --- Set statusline ----------------------------------------------------"

" Load webdevicons config
lua require('webdevicons_config').my_setup()

" let s:bg=synIDattr(synIDtrans(hlID('StatusLine')),'bg')
let s:bg='NONE'
let s:nbsc=' '

function s:active_stl()
  if s:make_stl()
    let stl =' %#StatusLineMode#%-11{ndavid#stl#mode()}%*'
    let icon = luaeval("require'webdevicons_config'.get_icon"
          \ ."{do_hl={true,'StatusLine','StatusLineIcon'}}")
    let stl .= icon.'%f%{ndavid#stl#modified()}%<'.'%#StatusLineBranch#'
          \ .'%{ndavid#stl#branch(1)}%*%{ndavid#stl#sy_stats_wrapper()} '
    if s:show_ln==1 | let stl .= '%= %l(%02p%%):%-1c' | endif
    let &l:stl = stl
  endif
endfunction

function s:innactive_stl()
  if s:make_stl()
    let icon = luaeval("require'webdevicons_config'.get_icon{}")
    let stl = ' >>         '
          \.icon.'%f%{ndavid#stl#modified()}%<%{ndavid#stl#branch(0)}'
          \.'%{ndavid#stl#sy_stats_wrapper()} '
    let &l:stl = stl
  endif
endfunction

function ndavid#stl#modified()
  if &modifiable
    if &modified
      return '[+]'
    else | return '' | endif
  else | return '[-]' | endif
endfunction

function ndavid#stl#branch(active)
  let branch = FugitiveHead(8)
  if a:active
    if branch=~#'master\|main'
      execute 'hi StatusLineBranch guifg=#58ca73 guibg='.s:bg
    else | execute 'hi! link StatusLineBranch StatusLine' | endif
  endif
  return branch == '' ? '' : s:nbsc.'['.branch.']'
endfunction

function s:make_stl()
  return &ft!~'NvimTree\|vista_kind\|startify\|packer\|startuptime'
endfunction

function! ndavid#stl#sy_stats_wrapper()
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

function ndavid#stl#mode()
  let mode = mode()
  if match(['n','c'], mode)!=-1 | let fg='#949494'
  elseif match(['i','ix','s','S',"\<C-s>"], mode())!=-1
    let fg='#57b0b2'
  elseif match(['R'], mode)!=-1
    let fg='#ea6962'
  elseif match(['v','V',"\<C-v>"], mode)!=-1
    let fg='#a9e861'
  endif
  let mode_map = {
        \ 'n': 'NORMAL  ', 'i': 'INSERT  ', 'R': 'REPLACE ',
        \ 'v': 'VISUAL  ', 'V': 'V·LINE  ', "\<C-v>": 'V·BLOCK ',
        \ 'c': 'COMMAND ', 's': 'SELECT  ', 'S': 'S·LINE  ',
        \ "\<C-s>": 'S·BLOCK '
        \ }
  let mode = get(mode_map, mode, '')
  if mode=~'NORMAL\|COMMAND'
    execute 'hi StatusLineMode guifg='.fg.' gui=NONE'
  else
    execute 'hi StatusLineMode guifg='.fg.' gui=bold'
  endif
  if mode=='INSERT' | let mode = 'ʌʌ'.s:nbsc.mode
  elseif mode=='REPLACE' | let mode = 'vv'.s:nbsc.mode
  else | let mode = '>>'.s:nbsc.mode | endif
  return mode
endfunction

" Show line info
let s:show_ln = 0
function ndavid#stl#toggle_ln()
  if s:show_ln == 0
    let s:show_ln=1
    call s:active_stl()
  else
    let s:show_ln=0
    call s:active_stl()
  endif
endfunction
nnoremap <silent><expr><leader>sl ndavid#stl#toggle_ln()

" Update Statusline when entering/leaving
au WinEnter,BufEnter,BufWrite * call s:active_stl()
au WinLeave,BufLeave * call s:innactive_stl()

" Packer statusline
au FileType packer let &l:stl='%=  Packer %='
" Startify statusline
au User StartifyReady let &l:stl='%=  startify %='
" StartupTime statusline
au FileType startuptime let &l:stl='%=  StartupTime %='
" Terminal statusline
au TermOpen * let &l:stl='%=  terminal %='
