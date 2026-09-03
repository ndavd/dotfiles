local out = {}

local conform = require('conform')

local biome = { 'biome' }
local rumdl = { 'rumdl' }
local stylua = { 'stylua' }
local gofumpt = { 'gofumpt' }
local rustfmt = { 'rustfmt' }
local clangformat = { 'clang_format' }
local shellharden_shfmt = { 'shellharden', 'shfmt' }
local yamlfmt = { 'yamlfmt' }
local forgefmt = { 'forge_fmt' }
local sqlformatter = { 'sql_formatter' }
local texfmt = { 'tex-fmt' }
local taplo = { 'taplo' }
local qmlformat = { 'qmlformat' }
local kdlfmt = { 'kdlfmt' }

conform.setup({
  formatters_by_ft = {
    javascript = biome,
    typescript = biome,
    javascriptreact = biome,
    typescriptreact = biome,
    json = biome,
    jsonc = biome,
    css = biome,
    html = biome,
    markdown = rumdl,
    lua = stylua,
    go = gofumpt,
    rust = rustfmt,
    c = clangformat,
    cpp = clangformat,
    sh = shellharden_shfmt,
    yaml = yamlfmt,
    solidity = forgefmt,
    sql = sqlformatter,
    tex = texfmt,
    toml = taplo,
    qml = qmlformat,
    kdl = kdlfmt,
  },
  notify_on_error = true,
  default_format_opts = {
    lsp_format = 'fallback',
  },
})

Formatexpr = function()
  return conform.formatexpr({ timeout_ms = 10000 })
end

vim.o.formatexpr = 'v:lua.Formatexpr()'

return out
