-- Python linting, and the formatter conform calls on save. The other half of
-- the Python setup; see basedpyright.lua.

return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
