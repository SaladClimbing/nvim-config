-- settings.lua: Editor options, autocmds, and buffer tabline

vim.cmd.colorscheme("catppuccin")

vim.opt.nu = true                 -- enable line numbers
vim.opt.relativenumber = true     -- use relative line numbers
 
local tab_size = 4
vim.opt.tabstop = tab_size
vim.opt.softtabstop = tab_size
vim.opt.shiftwidth = tab_size
vim.opt.expandtab = true
vim.opt.smartindent = true
 
vim.opt.wrap = false
vim.opt.textwidth = 0              -- don't auto-wrap lines
 
vim.opt.incsearch = true -- incremental search

vim.opt.termguicolors = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- Hide netrw buffers from buffer list and auto-wipe on hide
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.buflisted = false
    vim.opt_local.bufhidden = "wipe"
  end,
  desc = "Netrw buffer cleanup",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.wo.wrap = false
  end,
  desc = "Disable visual line wrapping for all filetypes",
})

local skip_filetypes = {
  netrw = true,
  qf = true,
  help = true,
  man = true,
  TelescopePrompt = true,
  lspinfo = true,
  mason = true,
}



