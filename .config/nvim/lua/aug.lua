-- https://learnvimscriptthehardway.stevelosh.com/chapters/14.html
local out = {
  aug_name = 'Main'
}

local group = vim.api.nvim_create_augroup(out.aug_name, { clear = true })

out.add = function(event, opts)
  opts.group = group
  return vim.api.nvim_create_autocmd(event, opts)
end

return out
