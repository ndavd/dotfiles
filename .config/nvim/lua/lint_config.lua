require('lint').linters_by_ft = {
  vim = { 'vint' },
  plaintex = { 'chktex' },
  solidity = { 'solhint' },
}

require('aug').add({ 'BufWritePost', 'InsertLeave' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
