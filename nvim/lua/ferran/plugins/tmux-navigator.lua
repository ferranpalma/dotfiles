-- <C-h/j/k/l> moves between nvim splits AND tmux panes with the same four keys,
-- so the boundary between the two stops mattering.
--
-- Both halves are required and neither works alone: the tmux half is installed
-- via tpm in .tmux.conf, this is the nvim half.

return {
	"christoomey/vim-tmux-navigator",

	-- Listing the commands lets lazy load the plugin on first use rather than at
	-- startup; the keys below are what actually triggers it.
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
	},

	keys = {
		{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Window/pane left" },
		{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Window/pane down" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Window/pane up" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Window/pane right" },
	},
}
