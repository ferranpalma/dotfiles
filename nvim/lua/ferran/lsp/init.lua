-- Language servers: everything that is not a single server's own settings.
-- Each server is one file in ferran/lsp/servers/, returning its config table.
--
-- There is no nvim-lspconfig and no Mason here, and neither is missing:
--
--   * nvim 0.11 made vim.lsp.config() / vim.lsp.enable() native, so a server is
--     a handful of lines. nvim-lspconfig is now mostly a collection of those
--     same lines for hundreds of servers, of which five are relevant here.
--   * Mason is a second package manager living inside the editor. The servers
--     are in mise.toml instead, next to the other toolchain, so `mise install`
--     on a new machine is the only install step.
--
-- Keymaps are not defined here either, because nvim 0.11 ships them and they
-- attach by themselves as soon as a server is running:
--
--   K                  hover documentation
--   grn                rename symbol
--   gra                code action
--   grr                references
--   gri                implementations
--   grt                type definition
--   gO                 symbols in this file
--   gd  gD             definition / declaration
--   <C-s> (insert)     signature help
--   ]d  [d             next / previous diagnostic
--   <C-w>d             diagnostics for the line, in a floating window
--
-- Telescope gives nicer lists for some of these: <leader>fs for document
-- symbols and <leader>fd for diagnostics across the project.

-- Register and enable every file in servers/. Discovering them rather than
-- listing them means adding a server is adding one file, and nothing here has
-- to be edited to match.
local names = {}
for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/ferran/lsp/servers/*.lua", true)) do
	local name = vim.fn.fnamemodify(path, ":t:r")
	vim.lsp.config(name, require("ferran.lsp.servers." .. name))
	names[#names + 1] = name
end
vim.lsp.enable(names)

-- How diagnostics look. The default shows everything inline, which on a file
-- with many warnings turns into unreadable overlapping text.
vim.diagnostic.config({
	-- The sign column says a line has a problem; <C-w>d or ]d reads it. Inline
	-- text is limited to the line the cursor is on.
	virtual_text = { current_line = true, source = "if_many" },
	signs = true,
	underline = true,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		-- Native LSP completion, so there is no nvim-cmp or blink here.
		-- <C-y> accepts, <C-e> dismisses, <C-n>/<C-p> move through the list.
		if client:supports_method("textDocument/completion") then
			-- autotrigger on its own only fires on the server's `triggerCharacters`,
			-- which for most servers is just `.` and a couple of others. That is why
			-- completion appears after a dot but never while typing a plain
			-- identifier. Adding the word characters is nvim's own documented way to
			-- widen it (:help vim.lsp.completion.enable).
			--
			-- Word characters only, not all 95 printable ones as the help example
			-- does: this already covers typing an identifier, while not firing a
			-- request on every space and bracket.
			local provider = client.server_capabilities.completionProvider
			if provider then
				local chars = provider.triggerCharacters or {}
				for _, range in ipairs({ { 48, 57 }, { 65, 90 }, { 97, 122 } }) do -- 0-9 A-Z a-z
					for c = range[1], range[2] do
						chars[#chars + 1] = string.char(c)
					end
				end
				chars[#chars + 1] = "_"
				provider.triggerCharacters = chars
			end

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		-- Underline the other occurrences of whatever the cursor is on.
		if client:supports_method("textDocument/documentHighlight") then
			local group = vim.api.nvim_create_augroup("lsp_highlight_" .. args.buf, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = group,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = group,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
