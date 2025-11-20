local opt = vim.opt

opt.path:append("**")
opt.wildmenu = true
opt.incsearch = true
opt.hidden = true

opt.backup = false
opt.swapfile = false

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.smarttab = true
opt.shiftwidth = 4
opt.tabstop = 4

vim.cmd("syntax enable")
vim.g.rehash256 = 1

