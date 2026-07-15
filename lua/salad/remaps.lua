-- Leader Key --
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open file explorer' })

-- Telescope --
local telescopebuiltin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', telescopebuiltin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>pg', telescopebuiltin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>pb', telescopebuiltin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>ph', telescopebuiltin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', '<C-p>', telescopebuiltin.git_files, { desc = 'Searches git files'})
