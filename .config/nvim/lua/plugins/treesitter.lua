local out = {}

out.setup = function()
  local nvim_treesitter = require('nvim-treesitter')

  nvim_treesitter.setup({})

  require('ts_context_commentstring').setup({
    enable_autocmd = false,
  })

  require('aug').add('FileType', {
    callback = function()
      local success = pcall(vim.treesitter.start)
      if success then
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo.indentexpr = 'v:lua.require\'nvim-treesitter\'.indentexpr()'
      end
    end,
  })
end

out.parsers = {
  'asm',
  'awk',
  'bash',
  'c',
  'cairo',
  'circom',
  'cmake',
  'csv',
  'cuda',
  'diff',
  'dockerfile',
  'editorconfig',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'graphql',
  'html',
  'html_tags',
  'html_tags',
  'hyprlang',
  'ini',
  'javascript',
  'jq',
  'jsdoc',
  'json',
  'json5',
  'jsx',
  'latex',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'nix',
  'proto',
  'proto',
  'regex',
  'rust',
  'solidity',
  'sql',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'wgsl',
  'wgsl_bevy',
  'yaml',
  'zsh',
}

return out
