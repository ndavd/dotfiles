if exists('s:loaded')
  finish
endif
let s:loaded = 1

call ndavid#colors#set()
call ndavid#stl#set()
call ndavid#keymaps#set()
