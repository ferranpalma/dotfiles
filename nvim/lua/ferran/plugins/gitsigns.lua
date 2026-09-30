-- Which lines changed, in the sign column, plus acting on a single hunk.

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },

	opts = {
		on_attach = function(buf)
			local gs = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
			end

			-- ]c / [c to walk the changes, matching vimdiff's own keys.
			map("n", "]c", function()
				gs.nav_hunk("next")
			end, "Next git hunk")
			map("n", "[c", function()
				gs.nav_hunk("prev")
			end, "Previous git hunk")

			map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
			map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Blame line")
			map("n", "<leader>gd", gs.diffthis, "Diff this file")
		end,
	},
}
