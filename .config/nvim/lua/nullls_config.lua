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
  --[[ Let's just use eslint as formatter and if prettier is needed just setup `eslint-plugin-prettier` ]]
  -- formatting.prettier.with({
  --   filetypes = {
  --     'javascript',
  --     'javascriptreact',
  --     'typescript',
  --     'typescriptreact',
  --     'vue',
  --     'css',
  --     'scss',
  --     'less',
  --     'html',
  --     'json',
  --     'jsonc',
  --     'yaml',
  --     'markdown.mdx',
  --     'graphql',
  --     'handlebars',
  --   },
  -- }),
  formatting.eslint,
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
