-- telescope.lua: Fuzzy finder

-- fzf-native needs `make`/a C toolchain, which the minimal profile skips.
-- Telescope falls back to its Lua sorter there.
local dependencies = {
	"nvim-lua/plenary.nvim",
}

if not vim.g.salad_minimal then
	table.insert(dependencies, { "nvim-telescope/telescope-fzf-native.nvim", build = "make" })
end

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = dependencies,
	},
}
