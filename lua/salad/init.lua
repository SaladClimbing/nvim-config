-- salad/init.lua: Module entry point
-- Sets leader key and loads submodules in dependency order

vim.g.mapleader = " "

require("salad.lazy_init")  -- Plugin manager bootstrap + spec loader
require("salad.remaps")     -- Global keybindings
require("salad.settings")   -- Editor options, autocmds, buffer tabline

