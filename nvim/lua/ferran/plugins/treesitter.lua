-- Real syntax trees instead of regex highlighting.
--
-- This is the rewritten `main` branch, which is a different plugin from the old
-- `master` one: it only installs parsers and ships queries, and nvim itself
-- does the highlighting. It cannot be lazy-loaded, hence lazy = false. Building
-- parsers needs the tree-sitter CLI and a C compiler; the CLI comes from
-- mise.toml.

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local parsers = require("nvim-treesitter").install({
			"bash",
			"css",
			"diff",
			"dockerfile",
			"gitcommit",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"html",
			"javascript",
			"json",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		})

		-- install() is asynchronous, which is right when nvim is opened normally:
		-- the parsers compile in the background and the first file may briefly have
		-- no highlighting. But a headless `nvim +qa` would exit and kill the
		-- compile halfway. `bootstrap` sets this with --cmd, before this file runs,
		-- so that it can wait for the parsers to finish instead.
		if vim.g.ferran_sync_install == 1 then
			parsers:wait(600000) -- 10 minutes; a cold build of all of them is slow
		end

		-- Highlighting is nvim's job and is not switched on automatically: start it
		-- for any filetype that has a parser available.
		--
		-- Treesitter indentation is skipped on purpose. The plugin still labels it
		-- experimental, and nvim's own ftplugin indentation plus format-on-save is
		-- more predictable.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				-- get_lang() falls back to returning the filetype itself, so it never
				-- rules anything out: "netrw" comes back as "netrw".
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end

				-- The availability check has to look at what add() RETURNS. It reports
				-- a missing parser by returning nil rather than raising, so a bare
				-- pcall() succeeds and the start() below then throws "Parser could not
				-- be created" on every buffer without a parser.
				local ok, added = pcall(vim.treesitter.language.add, lang)
				if not ok or not added then
					return -- no parser: plain syntax highlighting stays
				end

				vim.treesitter.start(args.buf, lang)
			end,
		})
	end,
}
