-- Buffers (tabs) --
vim.o.hidden = true -- Allow modified buffers in background (don't force save on switch)
vim.o.switchbuf = "usetab" -- Reuse existing window for buffer switch

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "New buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", ":bd!<CR>", { desc = "Force close buffer" })
vim.keymap.set("n", "<leader>bh", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bl", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "List buffers" })

-- Leader Key --
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- Telescope --
local telescopebuiltin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", telescopebuiltin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>pg", telescopebuiltin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>pb", telescopebuiltin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>ph", telescopebuiltin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "<C-p>", telescopebuiltin.git_files, { desc = "Searches git files" })
