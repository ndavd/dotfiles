require('lint').linters_by_ft = {
  vim = { 'vint' },
  plaintex = { 'chktex' },
  solidity = { 'solhint' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
