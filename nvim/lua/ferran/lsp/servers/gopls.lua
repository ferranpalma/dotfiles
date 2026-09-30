-- Go. Installed by mise as go:golang.org/x/tools/gopls, so its version can be
-- pinned per project alongside the Go it is meant to match.

return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },

	-- go.work before go.mod, so a multi-module workspace gets one server that can
	-- see across the modules rather than one server per module.
	root_markers = { "go.work", "go.mod", ".git" },

	settings = {
		gopls = {
			analyses = { unusedparams = true },
			staticcheck = true,
		},
	},
}
