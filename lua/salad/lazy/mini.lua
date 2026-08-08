-- mini.lua: Collection of standalone mini.nvim modules for editing & workflow.
-- Keymaps defined here are module defaults, documented in keybinds.md.

return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		-- Text Editing --
		-- mini.comment: `gcc` comment line, `gc{motion}` comment motion, `gc` in visual.
		require("mini.comment").setup()
		-- mini.pairs: auto-pair brackets/quotes; `<BS>` inside a pair deletes both.
		require("mini.pairs").setup()
		-- mini.surround: `sa` add, `sd` delete, `sf`/`sF` find, `sh` highlight,
		--                `sr` replace, `sn` update n-lines.
		require("mini.surround").setup({
			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",
			},
		})

		-- General Workflow --
		-- mini.diff: git diff gutter; `[h`/`]h` prev/next hunk, `gh` stage, `gH` reset.
		require("mini.diff").setup()
		-- mini.bufremove: used by `<leader>bd` / `<leader>bD` in remaps.lua.
		require("mini.bufremove").setup()
		-- mini.tabline: VS Code-style buffer tabline (replaces default tabline).
		require("mini.tabline").setup()
		-- mini.trailspace: highlights trailing whitespace; `:MiniTrailspaceClean` removes it.
		require("mini.trailspace").setup()

		-- Appearance --
		-- mini.hipatterns: highlights hex colors inline (replaces nvim-colorizer).
		require("mini.hipatterns").setup({
			highlighters = {
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})

		-- Misc. --
	end,
}
