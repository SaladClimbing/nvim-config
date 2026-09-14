-- rnvim.lua: R.nvim plugin for R development

return {
	"R-nvim/R.nvim",
	lazy = false,
	config = function()
		vim.g.R_filetypes = { "r", "rnoweb", "rmd", "rhelp" }
		---@type RConfigUserOpts
		local opts = {
			R_app = "radian",
			R_args = { "--quiet", "--no-save" },
			min_editor_width = 72,
			rconsole_width = 78,
			auto_start = "on startup",
			objbr_auto_start = true,
			bracketed_paste = true,
			hook = {
				on_filetype = function()
					vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
					vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
				end,
			},
			objbr_mappings = {
				c = "class",
				["<localleader>gg"] = "head({object}, n = 15)",
				v = function()
					require("r.browser").toggle_view()
				end,
			},
			disable_cmds = {
				"RClearConsole",
				"RCustomStart",
				"RSPlot",
				"RSaveClose",
			},
		}
		require("r").setup(opts)
	end,
}
