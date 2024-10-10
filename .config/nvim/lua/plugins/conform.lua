local out = {}

local conform = require('conform')

local prettierd = { 'prettierd', 'prettier' }
local denofmt = { 'deno_fmt' }
local stylua = { 'stylua' }
local gofmt = { 'gofmt' }
local rustfmt = { 'rustfmt' }
local clangformat = { 'clang_format' }
local shellharden = { 'shellharden' }
local yamlfmt = { 'yamlfmt' }
local forgefmt = { 'forge_fmt' }

conform.setup({
  formatters_by_ft = {
    javascript = prettierd,
    typescript = prettierd,
    javascriptreact = prettierd,
    typescriptreact = prettierd,
    markdown = denofmt,
    lua = stylua,
    go = gofmt,
    rust = rustfmt,
    c = clangformat,
    cpp = clangformat,
    sh = shellharden,
    yaml = yamlfmt,
    solidity = forgefmt,
  },
  notify_on_error = true,
  -- log_level = vim.log.levels.DEBUG,
})

Formatexpr = function()
  return conform.formatexpr({ timeout_ms = 10000, lsp_fallback = true })
end

vim.o.formatexpr = 'v:lua.Formatexpr()'

return out
