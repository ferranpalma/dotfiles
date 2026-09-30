-- A toggleable file tree in a side panel, the same explorer NvChad uses.
--
-- netrw is switched off in core/options.lua rather than here: netrw loads
-- during startup, so doing it from a plugin spec would be too late. That is
-- also what lets `nvim .` open the tree instead of a netrw listing.
--
-- Inside the tree, the keys worth knowing are nvim-tree's own defaults:
--   <CR> or o   open the file (or expand/collapse a folder)
--   v  /  s     open it in a VERTICAL / horizontal split  <- the splits answer
--   t           open it in a new tab page
--   a  d  r  x  c  p    create, delete, rename, cut, copy, paste
--   H  /  I     toggle dotfiles / gitignored files
--   R           refresh
--   ?           the full list of mappings
--
-- Note `v` and `s` above: opening into a split is a property of how the file is
-- opened, exactly as it is in the telescope pickers (<C-v>, <C-x>).

return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- Not lazy-loaded. The plugin has to be running before the directory buffer
	-- is created for `nvim .` to open the tree, which a keys/cmd trigger cannot
	-- guarantee. It is small enough that this does not show up in startup time.
	lazy = false,

	keys = {
		{ "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		{ "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Explorer on the current file" },
		{ "<leader>ec", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
		{ "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
	},

	opts = {
		view = {
			side = "right",
			width = 35,
			relativenumber = true,
		},

		renderer = {
			indent_markers = { enable = true },
			icons = {
				glyphs = {
					folder = {
						arrow_closed = "",
						arrow_open = "",
					},
				},
			},
		},

		actions = {
			open_file = {
				-- The window picker asks which window to open into whenever more than
				-- one is on screen, which turns every open into a second prompt. Off,
				-- the file goes to the last used window, and v/s/t still say
				-- explicitly where it should go.
				window_picker = { enable = false },
			},
		},

		filters = {
			custom = { ".DS_Store" },
		},

		-- Show ignored files, greyed out, rather than hiding them: build output and
		-- vendored directories are often exactly what needs looking at. `I` inside
		-- the tree toggles this per session.
		git = { ignore = false },
	},
}
