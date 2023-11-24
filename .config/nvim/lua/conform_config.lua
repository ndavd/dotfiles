local out = {}

local utils = require('conform.util')

local eslint_files = {
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
}
local prettier_files = {
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
}

---@param files string[]
local with_package_json = function(files)
  local arr = {}
  for i, f in ipairs(files) do
    arr[i] = f
  end
  table.insert(arr, 'package.json')
  return arr
end

---@param path string
---@param files string|string[]
---@return string|nil
local get_path_to_file = function(path, files)
  local found = vim.fs.find(files, { upward = true, path })
  if #found == 0 then
    return nil
  end
  return found[1]
end

local eslintd = { 'eslint_d' }
local eslintd_prettier = { 'eslint_d', { 'prettierd', 'prettier' } }
local denofmt = { 'deno_fmt' }
local stylua = { 'stylua' }
local gofmt = { 'gofmt' }
local rustfmt = { 'rustfmt' }
local clangformat = { 'clang_format' }
local shellharden = { 'shellharden' }

local js_ts_x = function()
  local root = vim.lsp.buf.list_workspace_folders()[1]

  if get_path_to_file(root, prettier_files) then
    return eslintd_prettier
  end

  -- Check for package.json config entry
  local package_json_path = get_path_to_file(root, 'package.json')
  if package_json_path then
    local package_json =
      vim.json.decode(table.concat(vim.fn.readfile(package_json_path)))
    if package_json['prettier'] ~= nil then
      return eslintd_prettier
    end
  end

  return eslintd
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
    eslint_d = { cwd = utils.root_file(with_package_json(eslint_files)) },
    prettier = { cwd = utils.root_file(with_package_json(prettier_files)) },
    prettierd = { cwd = utils.root_file(with_package_json(prettier_files)) },
  },
  notify_on_error = true,
})

local supports_buffer_formatting = function()
  return vim.iter(vim.lsp.get_clients({ bufnr = 0 })):any(function(c)
    return c.supports_method(vim.lsp.protocol.Methods.textDocument_formatting)
  end)
end

out.formatexpr = function()
  local timeout_ms = 10000
  local n = require('conform').formatexpr({ timeout_ms })

  if n == 0 then
    return 0
  end

  local whole_buffer_selected = vim.v.count == vim.fn.line('$')
  if whole_buffer_selected and supports_buffer_formatting() then
    -- Execute LSP buffer format (useful for those LSPs which don't support range formatting)
    vim.lsp.buf.format({ bufnr = 0, timeout_ms })
    return 0
  end

  -- Fallback
  return 1
end

return out
