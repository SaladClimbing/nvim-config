-- lazy_init.lua: Bootstrap lazy.nvim and load all plugin specs

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Minimal profile: core editing only. No Mason/LSP, completion, formatters,
-- or plugins that need node/go/rust. Keep this list in sync with lua/salad/lazy/.
local minimal_specs = {
  "theme",
  "treesitter",
  "telescope",
  "mini",
  "lualine",
  "whichkey",
  "vim-tmux-navigator",
  "tpipeline",
  "markdown",
}

-- Import individual spec files. lazy.nvim's directory import pulls in every
-- file in lua/salad/lazy/, which is what the full profile wants.
local function load_specs(names)
  local specs = {}
  for _, name in ipairs(names) do
    local ok, spec = pcall(require, "salad.lazy." .. name)
    if ok and type(spec) == "table" then
      if type(spec[1]) == "string" then
        specs[#specs + 1] = spec -- single plugin spec
      else
        vim.list_extend(specs, spec) -- list of plugin specs
      end
    else
      vim.notify("salad: failed to load spec " .. name, vim.log.levels.WARN)
    end
  end
  return specs
end

require("lazy").setup({
  spec = vim.g.salad_minimal and load_specs(minimal_specs) or "salad.lazy",
  change_detection = { notify = false },
})
