-- https://learnvimscriptthehardway.stevelosh.com/chapters/14.html
local out = {}

out.aug_name = 'Main'

out.setup = function()
  vim.api.nvim_create_augroup(out.aug_name, {})
end

out.add_autocmd = function(event, opts)
  local group = vim.api.nvim_create_augroup(out.aug_name, { clear = false })
  return vim.api.nvim_create_autocmd(
    event,
    vim.tbl_deep_extend('keep', { group = group }, opts)
  )
end

return out
