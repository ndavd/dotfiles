local aug = require('aug')

local gh = function(gh_path)
  return 'https://github.com/' .. gh_path
end

local treesitter_config = require('plugins/treesitter')

aug.add('PackChanged', {
  callback = function(ev)
    local name, kind, active = ev.data.spec.name, ev.data.kind, ev.data.active

    local is_install_or_update = kind == 'install' or kind == 'update'

    local treesitter_name = 'nvim-treesitter'
    local blink_cmp_name = 'blink.cmp'

    if name == treesitter_name and is_install_or_update then
      if not active then
        vim.cmd.packadd(treesitter_name)
      end
      local treesitter = require(treesitter_name)
      treesitter.install(treesitter_config.parsers)
      treesitter.update()
    end

    if name == blink_cmp_name and is_install_or_update then
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
vim.pack.add({ gh('nvim-mini/mini.nvim') })
require('plugins/mini')

-- Treesitter --
vim.pack.add({
  gh('windwp/nvim-ts-autotag'),
  gh('JoosepAlviste/nvim-ts-context-commentstring'),
  gh('nvim-treesitter/nvim-treesitter'),
})
treesitter_config.setup()

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
aug.add({ 'FileType' }, {
  pattern = { 'noir' },
  callback = function(ev)
    vim.bo[ev.buf].commentstring = '// %s'
  end,
})
