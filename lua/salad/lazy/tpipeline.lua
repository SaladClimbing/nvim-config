-- tpipeline.lua: Tmux statusline integration (seamless with vim-tmux-navigator)

return {
	"vimpostor/vim-tpipeline",
	init = function()
		vim.g.tpipeline_restore = 1
	end,
}
