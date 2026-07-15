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
  undotree = true,
  lspinfo = true,
  mason = true,
}

-- Buffer tabline (VS Code-style tabs) --
vim.o.showtabline = 2

_G.buffer_tabline = function()
  local bufs = vim.api.nvim_list_bufs()
  local tabline = ""
  local cur_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local ft = vim.bo[buf].filetype
      if skip_filetypes[ft] then goto continue end
      local name = vim.api.nvim_buf_get_name(buf)
      name = vim.fn.fnamemodify(name, ":t")
      if name == "" then name = "[No Name]" end
      local mod = vim.bo[buf].modified and " [+]" or ""
      local hi = buf == cur_buf and "%#TabLineSel#" or "%#TabLine#"
      tabline = tabline .. hi .. " " .. name .. mod .. " "
    end
    ::continue::
  end
  return tabline
end

vim.o.tabline = "%!v:lua.buffer_tabline()"

local buffer_events = { "BufEnter", "BufAdd", "BufDelete", "BufWritePost" }
vim.api.nvim_create_autocmd(buffer_events, {
  callback = function()
    vim.o.tabline = "%!v:lua.buffer_tabline()"
  end,
  desc = "Refresh buffer tabline",
})

