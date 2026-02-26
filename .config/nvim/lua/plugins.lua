local gh = function(gh_path)
  return 'https://github.com/' .. gh_path
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind, active = ev.data.spec.name, ev.data.kind, ev.data.active

    local treesitter_name = 'nvim-treesitter'
    if name == treesitter_name and kind == 'update' then
      if not active then
        vim.cmd.packadd(treesitter_name)
      end
      vim.cmd('TSUpdate')
    end
  end,
})

-- Mini all things --
vim.pack.add({ gh('echasnovski/mini.nvim') })
require('plugins/mini')

-- Icon support --
vim.pack.add({
  gh('nvim-tree/nvim-web-devicons'),
  gh('yamatsum/nvim-nonicons'),
})
require('plugins/webdevicons')

-- Better file explorer --
vim.pack.add({ gh('stevearc/oil.nvim') })
require('plugins/oil')

-- Automatic indentation --
vim.pack.add({ gh('tpope/vim-sleuth') })
vim.g.sleuth_automatic = 0
vim.keymap.set('n', '<leader><leader>s', '<cmd>Sleuth<CR>')

-- Treesitter --
vim.pack.add({
  gh('windwp/nvim-ts-autotag'),
  gh('JoosepAlviste/nvim-ts-context-commentstring'),
  gh('nvim-treesitter/nvim-treesitter'),
})
require('plugins/treesitter')

-- LSP --
vim.pack.add({
  gh('hrsh7th/cmp-nvim-lsp'),
  gh('neovim/nvim-lspconfig'),
})
require('plugins/lspconfig')
vim.pack.add({ gh('stevearc/conform.nvim') })
require('plugins/conform')
vim.pack.add({ gh('mfussenegger/nvim-lint') })
require('plugins/lint')
vim.pack.add({
  gh('hrsh7th/vim-vsnip'),
  gh('hrsh7th/cmp-vsnip'),
  gh('rafamadriz/friendly-snippets'),
  gh('hrsh7th/cmp-path'),
  gh('ray-x/cmp-treesitter'),
  gh('f3fora/cmp-spell'),
  gh('hrsh7th/nvim-cmp'),
})
require('plugins/cmp')

-- Colorschemes --
vim.pack.add({ gh('Mofiqul/vscode.nvim') })
require('plugins.vscode')

-- Noir language support --
vim.pack.add({ gh('noir-lang/noir-nvim') })
