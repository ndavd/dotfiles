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

local node_modules_bin = 'node_modules/.bin'

local sources = {
  formatting.eslint.with({
    prefer_local = node_modules_bin,
  }),
  formatting.prettier.with({
    prefer_local = node_modules_bin,
    -- TODO: It is also possible to configure prettier using a package.json entry, it would be nice to check for that.
    -- Only enabling it if there's an explicit configuration for it
    condition = function(utils)
      return utils.root_has_file({
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.yml',
        '.prettierrc.yaml',
        '.prettierrc.json5',
        '.prettierrc.js',
        '.prettierrc.cjs',
        '.prettierrc.toml',
        'prettier.config.js',
        'prettier.config.cjs',
      })
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
