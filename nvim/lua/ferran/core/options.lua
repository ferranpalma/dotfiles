-- Editor options. Anything not set here keeps nvim's default on purpose.

-- Space as leader. Must be set before plugins load, so core is required first
-- from init.lua.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw off, because nvim-tree is the file explorer. This has to happen here,
-- at the very start: netrw is a standard plugin that loads during startup, and
-- setting these flags later (inside the nvim-tree spec, for instance) is too
-- late to stop it. Turning it off is also what lets `nvim .` open the tree.
-- `gx` is unaffected: since 0.10 it is native (vim.ui.open), not netrw's.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line numbers: absolute for the cursor line, relative elsewhere, so a motion
-- like 7k can be read straight off the gutter.
vim.o.number = true
vim.o.relativenumber = true

-- Always reserve the sign column. Without this the whole text shifts sideways
-- the moment gitsigns or an LSP diagnostic appears, which is very distracting.
vim.o.signcolumn = "yes"

vim.o.cursorline = true
vim.o.wrap = false
-- (cursorline is narrowed to the active window further down)
vim.o.scrolloff = 8 -- keep 8 lines of context above and below the cursor
vim.o.sidescrolloff = 8

-- Two spaces, expanded. Go overrides this below, gofmt insists on real tabs.
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.smartindent = true

-- Case-insensitive search until an uppercase letter is typed.
vim.o.ignorecase = true
vim.o.smartcase = true

-- New splits open right and below. The defaults are left and above, which is
-- the main reason splitting feels like it goes the wrong way.
vim.o.splitright = true
vim.o.splitbelow = true

-- Persistent undo, kept in $XDG_STATE_HOME/nvim/undo. Undo survives closing
-- the file, which removes most of the fear of a bad edit.
vim.o.undofile = true

-- Ask "save changes?" instead of refusing to close a modified buffer. Without
-- it, commands like :q on an unsaved buffer just fail with E37.
vim.o.confirm = true

-- Show :substitute results in a split while typing the command.
vim.o.inccommand = "split"

-- Completion menu behaviour. The default is only "menu,popup", which is the
-- reason completion looks like it works only sometimes:
--   menuone   show the menu even when there is exactly ONE match. Without it
--             the single-match case silently completes nothing visible.
--   noselect  do not preselect an entry, so typing keeps filtering instead of
--             having a guess inserted. <C-y> accepts, <C-n>/<C-p> move.
--   popup     show the item's documentation in a floating window.
--   fuzzy     match subsequences, not just prefixes ("fpl" finds "fmt.Println").
vim.o.completeopt = "menu,menuone,noselect,popup,fuzzy"
vim.o.pumheight = 12 -- cap the menu instead of letting it fill the window

-- The system clipboard is deliberately NOT the default register: y and d stay
-- private to nvim, the same way the tmux config keeps copying explicit.
-- Use "+y to yank to macOS and "+p to paste from it.

-- Remote plugin providers, for plugins written in Python, Ruby, Perl or Node.
-- Nothing here uses one, and switching them off removes four :checkhealth
-- warnings and the startup cost of looking for interpreters that are not there.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- gofmt uses tabs, so undo the two-space default for Go only. conform formats
-- on save anyway, but this keeps the file correct while typing.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.bo.expandtab = false
		vim.bo.shiftwidth = 4
		vim.bo.tabstop = 4
		vim.bo.softtabstop = 4
	end,
})

-- Highlight the cursor line ONLY in the window that holds the cursor.
--
-- 'cursorline' is a window option, so setting it globally lights up a line in
-- every window at once and nothing on screen then says which one is focused.
-- That is worse than it sounds here, because in nvim's default colourscheme
-- CursorLine and StatusLineNC are the same grey (#2c2e33).
--
-- With this, the highlighted line is the answer to "which window am I in?".
local cursorline = vim.api.nvim_create_augroup("ferran_cursorline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
	group = cursorline,
	callback = function()
		vim.wo.cursorline = true
	end,
})
vim.api.nvim_create_autocmd("WinLeave", {
	group = cursorline,
	callback = function()
		vim.wo.cursorline = false
	end,
})

-- Briefly highlight whatever was just yanked, as confirmation the motion
-- covered what was intended.
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})
