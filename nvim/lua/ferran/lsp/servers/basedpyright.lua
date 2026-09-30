-- Python types and navigation.
--
-- Python is split across two servers on purpose, which is how the Python
-- tooling works now: basedpyright does types and navigation, ruff does linting
-- and formatting. Both attach to the same buffer.

return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },

	settings = {
		basedpyright = {
			analysis = {
				-- basedpyright defaults to "all", which is very loud on code that was
				-- not written for it.
				typeCheckingMode = "standard",
				diagnosticMode = "openFilesOnly",
			},
		},
	},
}
