-- lazy.nvim (https://lazy.folke.io): bootstrap, and where the plugin list comes
-- from. The list itself is not here: `import` makes lazy read every file in
-- ferran/plugins/, each of which returns one plugin's spec. Adding a plugin is
-- therefore adding a file, and removing one is deleting it.
--
--   :Lazy         status dashboard
--   :Lazy update  update plugins and rewrite the lockfile (never automatic,
--                 same as `brew bundle` never upgrading)
--   :Lazy restore reinstall exactly what the lockfile pins
--
-- nvim/lazy-lock.json is generated, and belongs in the repo: it is what makes
-- another machine get these exact commits. Plugins themselves are data, not
-- config, so they are installed under $XDG_DATA_HOME/nvim/lazy, the same
-- reasoning as the tmux plugin path.

-- Clone lazy.nvim itself on a machine that does not have it yet.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Could not clone lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { { import = "ferran.plugins" } },

	-- No colourscheme is installed yet, so tell lazy to use a built-in one for
	-- its own install window instead of guessing.
	install = { colorscheme = { "habamax" } },

	-- Never check for updates in the background: updates are an explicit
	-- `:Lazy update`, the same way `brew bundle` never upgrades on its own.
	checker = { enabled = false },
	change_detection = { notify = false },

	-- No plugin here needs luarocks, and leaving it on makes :checkhealth report
	-- a permanent error about a luarocks install that will never happen.
	rocks = { enabled = false },
})
