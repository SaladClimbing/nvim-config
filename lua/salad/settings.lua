vim.cmd.colorscheme("catppuccin")
 
vim.opt.nu = true                 -- set line numbers -- set line numbers
vim.opt.relativenumber = true     -- use relative line numbers
 
-- set tab size to 2 spaces
local tab_size = 4
vim.opt.tabstop = tab_size
vim.opt.softtabstop = tab_size
vim.opt.shiftwidth = tab_size
vim.opt.expandtab = true
vim.opt.smartindent = true
 
vim.opt.wrap = false
 
vim.opt.incsearch = true -- incremental search

vim.opt.termguicolors = true

