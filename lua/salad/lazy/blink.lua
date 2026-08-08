-- blink.lua: Autocompletion via blink.cmp (replaces mini.completion)

return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			-- Start from the "super-tab" preset, then override:
			-- Tab/Shift-Tab fall back to native behavior when the menu is closed.
			preset = "super-tab",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		completion = {
			documentation = { auto_show = true },
			ghost_text = { enabled = true },
		},
		appearance = { nerd_font_variant = "mono" },
		sources = {
			-- Order determines priority: LSP first, then path/snippets/buffer.
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
