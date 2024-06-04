-- Settings
vim.g.mapleader = ' '
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.wrap = false
vim.o.clipboard = 'unnamedplus'
vim.o.showmode = false
vim.o.errorbells = false
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.hlsearch = false
vim.o.list = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.pumblend = 15
vim.o.textwidth = 80
vim.o.completeopt = 'menuone,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.inccommand = 'split'
vim.o.foldmethod = 'marker'

-- Title
vim.o.title = true
vim.o.titlestring = '%t %m - NVIM'

-- Change guicursor
vim.o.guicursor = 'i-r:hor20-Cursor'

-- Mouse
vim.o.mouse = 'a'
vim.o.mousemodel = 'extend'
vim.o.selection = 'inclusive'

-- Fix highlight errors
vim.g.vimsyn_noerror = 1

-- Setup main augroup
local aug = require('aug')

-- Highlight when yanking
aug.add({ 'TextYankPost' }, {
  pattern = '*',
  callback = function()
    require('vim.highlight').on_yank()
  end,
})

-- Rasi (rofi theme file)
aug.add({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.rasi',
  callback = function()
    vim.bo.syntax = 'css'
  end,
})

-- Markdown
aug.add({ 'FileType' }, {
  pattern = 'markdown',
  callback = function()
    vim.wo.conceallevel = 2
  end,
})

require('plugins')
require('colors')
require('keymaps')
require('stl')
