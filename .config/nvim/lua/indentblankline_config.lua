require('indent_blankline').setup({
  enabled = false,
  char = ' ',
  show_end_of_line = true,
  buftype_exclude = {
    'terminal',
    'help',
  },
  filetype_exclude = {
    'startify',
    'man',
    'vista_kind',
    'TelescopePrompt',
  },
  char_highlight_list = {
    'IndentBlankline1',
    'IndentBlankline2',
  },
  space_char_highlight_list = {
    'IndentBlankline1',
    'IndentBlankline2',
  },
})
