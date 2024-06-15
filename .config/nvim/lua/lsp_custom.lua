local out = {}

local filter = function(arr, fn)
  if type(arr) ~= 'table' then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local filterDTS = function(value)
  return string.match(value.filename, '%.d.ts') == nil
end

local on_list = function(options)
  -- https://github.com/typescript-language-server/typescript-language-server/issues/216
  local items = options.items
  if #items > 1 then
    items = filter(items, filterDTS)
  end

  vim.fn.setqflist(
    {},
    ' ',
    { title = options.title, items = items, context = options.context }
  )
  vim.api.nvim_command('cfirst')
end

out.definition = function()
  vim.lsp.buf.definition({ on_list = on_list })
end

out.cd_project_root = function()
  local ok, workspace_folders_or_err = pcall(vim.lsp.buf.list_workspace_folders)
  if ok and #workspace_folders_or_err > 0 then
    vim.cmd('cd ' .. workspace_folders_or_err[1])
  else
    print('Can\'t find project\'s root directory')
  end
end

out.goto_next_diagnostic = function()
  vim.diagnostic.jump({ count = 1, float = true })
  vim.diagnostic.open_float()
end

out.goto_prev_diagnostic = function()
  vim.diagnostic.jump({ count = -1, float = true })
  vim.diagnostic.open_float()
end

out.toggle_buf_inlay_hints = function()
  vim.lsp.inlay_hint.enable(
    not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }),
    { bufnr = 0 }
  )
end

return out
