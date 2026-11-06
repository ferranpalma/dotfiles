-- Rust. rust-analyzer is a rustup component of the rust in mise.toml, not a
-- separate install, so it always matches the compiler the project builds with.

return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },

	-- Cargo.lock before Cargo.toml: every crate of a workspace has its own
	-- Cargo.toml, but only the workspace root has the lock file. Looking for it
	-- first gives one server for the whole workspace rather than one per crate.
	root_markers = { "Cargo.lock", "Cargo.toml", ".git" },

	settings = {
		["rust-analyzer"] = {
			-- clippy instead of `cargo check` when a file is saved: the same compiler
			-- errors, plus clippy's lints.
			check = { command = "clippy" },
		},
	},
}
