local formatting = require('null-ls').builtins.formatting
local diagnostics = require('null-ls').builtins.diagnostics
local utils = require('null-ls.utils')

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

local should_load_prettier = function(condition_utils)
  -- Check for config files
  if
    condition_utils.root_has_file({
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
  then
    return true
  end

  -- Check for package.json config entry
  if condition_utils.root_has_file({ 'package.json' }) then
    local package_json_path = utils.get_root() .. '/package.json'
    local package_json = vim.json.decode(table.concat(vim.fn.readfile(package_json_path)))
    return package_json['prettier'] ~= nil
  end

  return false
end

local sources = {
  formatting.eslint.with({
    prefer_local = node_modules_bin,
  }),
  formatting.prettier.with({
    prefer_local = node_modules_bin,
    condition = function(condition_utils)
      return should_load_prettier(condition_utils)
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
