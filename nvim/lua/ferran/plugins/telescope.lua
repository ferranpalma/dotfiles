-- The fuzzy finder. This is the piece that makes buffers and splits usable, so
-- its keymaps are the ones worth memorising.
--
-- Inside any picker, WHERE to open is chosen at the moment of opening, which is
-- the step that is easy to miss:
--   <CR>   open in the current window
--   <C-v>  open in a vertical split
--   <C-x>  open in a horizontal split
--   <C-t>  open in a new tab page
--   <C-q>  send every result to the quickfix list (then travel with ]q)

return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",

	keys = {
		-- Leader twice for the list of open buffers: the answer to "where did that
		-- file go?". Cheapest possible keystroke because it is used most.
		{ "<leader><leader>", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep in project" },
		{ "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Symbols in file" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
		-- Reopen the last picker with its query and cursor position intact.
		{ "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },
	},

	-- A function, not a table: it has to require telescope.actions, and a plain
	-- table would be evaluated while this file is read, before telescope is on
	-- the runtimepath.
	opts = function()
		local actions = require("telescope.actions")
		return {
			defaults = {
				-- Esc closes the picker straight from insert mode. By default it only
				-- drops into the picker's normal mode, which means pressing Esc twice
				-- to get out of something opened by accident.
				mappings = {
					i = { ["<Esc>"] = actions.close },
				},
				-- Prompt on top, results under it, preview on the right.
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top", preview_width = 0.55 },
				sorting_strategy = "ascending",
			},
			pickers = {
				find_files = {
					-- fd respects .gitignore and is much faster than the `find` fallback.
					-- --hidden shows dotfiles, which is the whole point on this machine;
					-- .git itself is still noise.
					find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
				},
				buffers = {
					-- Most recently used first, and <C-d> closes a buffer straight from
					-- the list.
					sort_mru = true,
					ignore_current_buffer = true,
					mappings = {
						i = { ["<C-d>"] = actions.delete_buffer },
					},
				},
			},
		}
	end,
}
