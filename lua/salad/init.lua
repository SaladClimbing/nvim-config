-- salad/init.lua: Module entry point
-- Sets leader key and loads submodules in dependency order

vim.g.mapleader = " "

-- Minimal profile: set by install.sh (SALAD_MINIMAL=1) or by the .minimal
-- marker next to init.lua. Env var wins so a full install can override a
-- stale marker: SALAD_MINIMAL=0 nvim
local minimal_env = vim.env.SALAD_MINIMAL
if minimal_env ~= nil and minimal_env ~= "" then
  vim.g.salad_minimal = minimal_env == "1" or minimal_env == "true"
else
  local marker = vim.fn.stdpath("config") .. "/.minimal"
  vim.g.salad_minimal = vim.fn.filereadable(marker) == 1
end

require("salad.lazy_init") -- Plugin manager bootstrap + spec loader
require("salad.remaps") -- Global keybindings
require("salad.settings") -- Editor options, autocmds, buffer tabline
