-- The bar across the top listing what is open, so the buffer list is visible
-- instead of having to ask for it with <leader><leader>.
--
-- mode = "buffers", NOT the "tabs" this was set to before. They look identical
-- and mean opposite things:
--
--   buffers  one entry per OPEN FILE. Opening a file adds an entry. This is
--            what makes "which files do I have open" answerable at a glance.
--   tabs     one entry per TAB PAGE, i.e. per window layout. Opening a file
--            adds nothing, because a tab page is a workspace, not a file. The
--            bar then looks like VS Code's tabs but almost never changes,
--            which is a good way to stay confused about the difference.
--
-- Cycling is the built-in ]b and [b; no remap, because the bar shows buffers in
-- buffer-number order, which is exactly the order those two follow.

return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	event = "VeryLazy",

	keys = {
		-- Jump straight to a buffer by the letter shown on it. This is the
		-- "select which file I am in" answer when several are open.
		{ "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick a buffer by letter" },
		{ "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Close a buffer by letter" },
	},

	opts = {
		options = {
			mode = "buffers",
			separator_style = "slant",
			diagnostics = "nvim_lsp",

			-- Keep the bar clear of the file tree rather than running underneath it.
			offsets = {
				{
					filetype = "NvimTree",
					text = "Files",
					separator = true,
					text_align = "center",
				},
			},
		},
	},
}
