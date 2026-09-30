-- TypeScript and JavaScript.
--
-- vtsls rather than typescript-language-server: TypeScript 7 is the Go rewrite
-- and dropped tsserver.js, which typescript-language-server requires, so that
-- server cannot start at all once TS 7 is what is installed. vtsls carries its
-- own TypeScript 5.9, so it does not depend on the system one.

return {
	cmd = { "vtsls", "--stdio" },

	-- javascriptreact / typescriptreact are what nvim calls .jsx and .tsx. The
	-- old compound names (javascript.jsx) are not filetypes nvim knows.
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},

	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}
