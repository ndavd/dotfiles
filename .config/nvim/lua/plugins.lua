local gh = function(gh_path)
  return 'https://github.com/' .. gh_path
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind, active = ev.data.spec.name, ev.data.kind, ev.data.active

    local treesitter_name = 'nvim-treesitter'
    local blink_cmp_name = 'blink.cmp'

    if name == treesitter_name and kind == 'update' then
      if not active then
        vim.cmd.packadd(treesitter_name)
      end
      vim.cmd('TSUpdate')
    end

    if name == blink_cmp_name and (kind == 'install' or kind == 'update') then
      local obj = vim
        .system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path })
        :wait()
      if obj.code ~= 0 then
        print(obj.stderr)
      end
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
  gh('rafamadriz/friendly-snippets'),
  gh('saghen/blink.cmp'),
})
require('plugins/cmp')
vim.pack.add({ gh('neovim/nvim-lspconfig') })
require('plugins/lspconfig')
vim.pack.add({ gh('stevearc/conform.nvim') })
require('plugins/conform')
vim.pack.add({ gh('mfussenegger/nvim-lint') })
require('plugins/lint')

-- Colorschemes --
vim.pack.add({ gh('Mofiqul/vscode.nvim') })
require('plugins.vscode')

-- Noir language support --
vim.pack.add({ gh('noir-lang/noir-nvim') })
