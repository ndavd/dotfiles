local formatting = require('null-ls').builtins.formatting
local diagnostics = require('null-ls').builtins.diagnostics

local extra_args = {
  formatting = {
    stylua = {
      '--indent-type',
      'Spaces',
      '--indent-width',
      '2',
      '--quote-style',
      'ForceSingle',
    },
  },
}

local sources = {
  formatting.eslint,
  formatting.prettier.with({
    runtime_condition = function(params)
      local utils = require('null-ls.utils')
      -- use whatever root markers you want to check - these are the defaults
      local root = utils.root_pattern('.null-ls-root', 'Makefile', '.git')(params.bufname)
      return root and utils.path.exists(utils.path.join(root, '.prettierrc'))
    end,
  }),
  formatting.deno_fmt.with({
    filetypes = { 'markdown' },
  }),
  formatting.stylua.with({
    extra_args = extra_args.formatting.stylua,
  }),
  formatting.gofmt,
  formatting.rustfmt,
  formatting.clang_format,
  formatting.shellharden,
  diagnostics.vint,
  diagnostics.chktex,
  diagnostics.solhint,
}

require('null-ls').setup({
  sources = sources,
})
