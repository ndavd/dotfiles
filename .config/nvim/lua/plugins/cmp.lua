require('blink.cmp').setup({
  keymap = {
    preset = 'enter',
    ['<C-u>'] = {
      function(cmp)
        cmp.scroll_documentation_up(4)
      end,
    },
    ['<C-d>'] = {
      function(cmp)
        cmp.scroll_documentation_down(4)
      end,
    },
  },
  completion = {
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    documentation = {
      auto_show = true,
      window = {
        winblend = vim.o.pumblend,
      },
    },
    menu = {
      border = 'solid',
      winblend = vim.o.pumblend,
      max_height = 99,
    },
  },
  signature = {
    enabled = true,
    window = {
      winblend = vim.o.pumblend,
    },
  },
  fuzzy = {
    sorts = {
      'exact',
      'score',
      'sort_text',
    },
  },
})
