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
  formatting.prettier,
  formatting.stylua.with({ extra_args = extra_args.formatting.stylua }),
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
