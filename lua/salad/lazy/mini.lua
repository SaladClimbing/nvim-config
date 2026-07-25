return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		-- Text Editing --
		require("mini.comment").setup()
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

		-- Appearance --

		-- Misc. --
	end,
}
