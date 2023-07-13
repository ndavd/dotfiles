if exists('s:loaded')
  finish
endif
let s:loaded = 1

call ndavd#colors#set()
call ndavd#stl#set()
call ndavd#keymaps#set()
