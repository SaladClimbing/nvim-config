return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		-- Text Editing --
		require("mini.comment").setup()
		require("mini.pairs").setup()
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
		require("mini.diff").setup()
		require("mini.bufremove").setup()
		require("mini.tabline").setup()
		require("mini.trailspace").setup()

		-- Appearance --
		require("mini.hipatterns").setup({
			highlighters = {
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})

		-- Misc. --
	end,
}
