local out = {}

local utils = require('conform.util')

local eslintd = { 'eslint_d' }
local prettier = { 'prettier' }
local denofmt = { 'deno_fmt' }
local stylua = { 'stylua' }
local gofmt = { 'gofmt' }
local rustfmt = { 'rustfmt' }
local clangformat = { 'clang_format' }
local shellharden = { 'shellharden' }

---@param path string
---@param files string[]
---@return boolean
local has_file = function(path, files)
  for _, f in ipairs(files) do
    if vim.fn.filereadable(path .. '/' .. f) == 1 then
      return true
    end
  end
  return false
end

local js_ts_x = function()
  local root = vim.lsp.buf.list_workspace_folders()[1]

  if
    has_file(root, {
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      '.eslintrc.json',
    })
  then
    return eslintd
  end

  -- Check for package.json config entry
  local package_json_path = root .. '/' .. 'package.json'
  if vim.fn.filereadable(package_json_path) == 1 then
    local package_json =
      vim.json.decode(table.concat(vim.fn.readfile(package_json_path)))
    if package_json['eslintConfig'] ~= nil then
      return eslintd
    end
  end

  return prettier
end

require('conform').setup({
  formatters_by_ft = {
    javascript = js_ts_x,
    typescript = js_ts_x,
    javascriptreact = js_ts_x,
    typescriptreact = js_ts_x,
    markdown = denofmt,
    lua = stylua,
    go = gofmt,
    rust = rustfmt,
    c = clangformat,
    cpp = clangformat,
    sh = shellharden,
  },

  formatters = {
    eslint_d = {
      cwd = utils.root_file({
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json',
        'package.json',
      }),
    },
  },
  notify_on_error = true,
})

local supports_buffer_formatting = function()
  return vim.iter(vim.lsp.get_clients({ bufnr = 0 })):any(function(c)
    return c.supports_method(vim.lsp.protocol.Methods.textDocument_formatting)
  end)
end

out.formatexpr = function()
  local n = require('conform').formatexpr()

  if n == 0 then
    return 0
  end

  local whole_buffer_selected = vim.v.count == vim.fn.line('$')
  if whole_buffer_selected and supports_buffer_formatting() then
    -- Execute LSP buffer format (useful for those LSPs which don't support range formatting)
    vim.lsp.buf.format({ bufnr = 0, timeout_ms = 10000 })
    return 0
  end

  -- Fallback
  return 1
end

return out
