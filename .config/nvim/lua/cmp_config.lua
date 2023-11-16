local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'spell' },
  },
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
