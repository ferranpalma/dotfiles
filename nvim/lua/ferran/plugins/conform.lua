-- Format on save.
--
-- Explicit formatters where the language has one true answer, and the language
-- server as the fallback everywhere else, so a new filetype still gets
-- formatted without adding configuration for it.
--
-- The formatters themselves come from mise.toml, except gofmt, which ships with
-- the mise-managed Go.

return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",

	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format buffer",
		},
	},

	opts = {
		formatters_by_ft = {
			go = { "gofmt" },
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	},
}
