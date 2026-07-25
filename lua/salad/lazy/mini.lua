return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		-- Text Editing --
		require("mini.comment").setup()
		require("mini.completion").setup({
			mappings = {
				force_twostep = "<C-Space>",
				force_fallback = "<A-Space>",
				scroll_down = "<C-f>",
				scroll_up = "<C-b>",
			},
		})
		require("mini.pairs").setup()
		require("mini.snippets").setup()
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

		-- Override <CR> to confirm completion --
		vim.keymap.set("i", "<CR>", function()
			if vim.fn.pumvisible() == 1 then
				return "<C-y>"
			else
				return "<CR>"
			end
		end, { expr = true })
	end,
}
