-- Lua, which here mostly means editing this configuration.

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },

	settings = {
		Lua = {
			runtime = { version = "LuaJIT" }, -- nvim's Lua, not 5.1 or 5.4

			-- Only the nvim runtime, not every installed plugin: it is enough for
			-- completion on the vim.* API and keeps the server from indexing the
			-- whole of $XDG_DATA_HOME/nvim/lazy on startup.
			workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },

			-- `vim` is injected by nvim, so the server cannot know it exists.
			diagnostics = { globals = { "vim" } },

			telemetry = { enable = false },
		},
	},
}
