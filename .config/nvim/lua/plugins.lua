-- Bootstrapping
local fn = vim.fn
local execute = vim.api.nvim_command
local install_path =
  fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

require('packer').config = {
  profile = {
    enable = true,
    threshold = 1
  }
}

-- Plugins
return require('packer').startup(function(use)

  -- Packer --
  use 'wbthomason/packer.nvim'

  -- Icon support --
  use {
    'yamatsum/nvim-nonicons',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- Smooth Scrolling --
  use 'psliwka/vim-smoothie'

  -- Scrollbar --
  use 'dstein64/nvim-scrollview'

  -- Better start screen --
  use {'mhinz/vim-startify'}

  -- Better matchit --
  use 'andymass/vim-matchup'

  -- Indentation --
  use 'tpope/vim-sleuth'

  -- Indend guides --
  use 'lukas-reineke/indent-blankline.nvim'

  -- Auto comment --
  use 'numToStr/Comment.nvim'

  -- Easy Align --
  use {'junegunn/vim-easy-align', keys = {{'x', '<plug>(LiveEasyAlign)'}}}

  -- Hop --
  use {
    'phaazon/hop.nvim',
    as = 'hop',
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- Surround text --
  use 'tpope/vim-surround'

  -- Complete brackets --
  use 'jiangmiao/auto-pairs'

  -- Startuptime --
  use 'dstein64/vim-startuptime'

  -- RFC --
  use 'mhinz/vim-rfc'

  -- Cheat.sh --
  use 'dbeniamine/cheat.sh-vim'

  -- VimWiki --
  use 'vimwiki/vimwiki'

  -- Md previewer --
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}

  -- Colorizer --
  use {'norcalli/nvim-colorizer.lua'}

  -- Git --
  use 'tpope/vim-fugitive'
  use 'mhinz/vim-signify'

  -- Sql.nvim --
  use 'tami5/sql.nvim'

  -- Lua Scratchpad --
  use 'rafcamlet/nvim-luapad'

  -- View tags --
  use 'liuchengxu/vista.vim'

  -- Telescope --
  use {'nvim-telescope/telescope.nvim', requires = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
    'nvim-telescope/telescope-fzf-writer.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-frecency.nvim',
  }}

  -- Treesitter --
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', requires =
    'windwp/nvim-ts-autotag'}

  -- LSP --
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  -- use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'ray-x/cmp-treesitter'
  use 'f3fora/cmp-spell'
  use {
    'hrsh7th/cmp-vsnip',
    after = 'nvim-cmp',
    requires = {
      'hrsh7th/vim-vsnip',
      {
        'rafamadriz/friendly-snippets',
        after = 'cmp-vsnip'
      }
    }
  }

  -- Colorschemes --
  use 'gruvbox-community/gruvbox'
  use 'Mofiqul/vscode.nvim'

end)
