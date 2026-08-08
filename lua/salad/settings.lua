-- settings.lua: Editor options, autocmds, and colorscheme
-- Loaded after remaps; also applies the catppuccin colorscheme here.

vim.cmd.colorscheme("catppuccin")

-- Line numbers --
vim.opt.nu = true                 -- enable line numbers
vim.opt.relativenumber = true     -- use relative line numbers
 
-- Indentation --
local tab_size = 4
vim.opt.tabstop = tab_size
vim.opt.softtabstop = tab_size
vim.opt.shiftwidth = tab_size
vim.opt.expandtab = true          -- spaces, not tabs
vim.opt.smartindent = true        -- auto-indent on new lines
 
-- Wrapping --
vim.opt.wrap = false              -- no visual wrapping
vim.opt.textwidth = 0             -- don't auto-wrap lines
 
vim.opt.incsearch = true          -- incremental search

vim.opt.termguicolors = true      -- 24-bit color support

-- Folding via treesitter (see also nvim-treesitter config) --
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99            -- start with all folds open

-- Hide netrw buffers from buffer list and auto-wipe on hide
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.buflisted = false
    vim.opt_local.bufhidden = "wipe"
  end,
  desc = "Netrw buffer cleanup",
})

-- Enforce no-wrapping for every filetype (belt & suspenders to wrap = false)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.wo.wrap = false
  end,
  desc = "Disable visual line wrapping for all filetypes",
})



