-- remaps.lua: Global non-LSP keybindings

vim.o.hidden = true -- keep modified buffers in background
vim.o.switchbuf = "usetab" -- reuse existing window on buffer switch

-- Buffer navigation --
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "New buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", ":bd!<CR>", { desc = "Force close buffer" })
vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "List buffers" })

-- File explorer --
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- Telescope --
local telescopebuiltin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", telescopebuiltin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>pg", telescopebuiltin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>pb", telescopebuiltin.buffers, { desc = "List buffers" })
vim.keymap.set("n", "<leader>ph", telescopebuiltin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<C-p>", telescopebuiltin.git_files, { desc = "Searches git files" })

-- Show warnings inline --
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
