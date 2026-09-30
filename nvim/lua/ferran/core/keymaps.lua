-- Keymaps that do not belong to a plugin. Plugin keymaps live in that plugin's
-- own file under ferran/plugins/, so each plugin stays one self-contained unit.
--
--
-- THE THREE THINGS NVIM KEEPS SEPARATE
--
-- Conflating these is what makes splits feel unpredictable:
--
--   buffer     A file loaded in memory. `:e file` creates one. A buffer has no
--              relationship to what is on screen: 30 buffers can share 1
--              window. `:ls` lists them.
--   window     A viewport onto a buffer. Splitting creates windows. Two windows
--              can show the same buffer at different lines.
--   tab page   A layout of windows, i.e. a workspace. NOT a file, and not a
--              browser tab. `:tabnew` is for "a different arrangement of
--              windows", never for "one more file".
--
-- Opening a file replaces the buffer shown in THE CURRENT WINDOW. So when a
-- file seems to vanish, nothing was lost or closed: it is still a buffer, just
-- not on screen. Bring it back with <leader><leader>, or `:b <name>`.
--
-- To put a file in a split, the split has to be part of the request:
--   :vsplit file      open file in a new vertical split
--   :split  file      same, horizontally
--   <leader>ff then <C-v>   pick a file and send it to a vertical split
--   inside the tree: v or s   open the file under the cursor in a split
--
-- And :q closes a WINDOW, not a file. With only one window open it therefore
-- quits nvim; that is not a bug. To leave a file use <leader><leader> or
-- <leader>bd, and keep :q for closing one split of several (:qa really quits).
--
--
-- DEFAULTS WORTH LEARNING, DELIBERATELY NOT REMAPPED
--
--   <C-w>v  <C-w>s     split vertically / horizontally (current buffer)
--   <C-w>q             close this window; the buffer stays loaded
--   <C-w>o             close every OTHER window ("only")
--   <C-w>=             make all windows equal size
--   <C-w>_  <C-w>|     maximise height / width
--   <C-w>H J K L       move this window to the far left/bottom/top/right
--   <C-w>T             move this window out into its own tab page
--   <C-^>              toggle between this buffer and the previous one
--   ]b  [b             next / previous buffer        (built in since 0.11)
--   ]q  [q             next / previous quickfix item (built in since 0.11)
--   gcc  gc{motion}    comment a line / a motion     (built in since 0.10)
--   grn grr gra gri gO LSP rename, references, code action, implementation,
--                      document symbols              (built in since 0.11)
--
-- <C-h/j/k/l> move between windows: defined by vim-tmux-navigator so that the
-- same four keys also cross into tmux panes. See its file in ferran/plugins/.

local map = vim.keymap.set

-- Clear search highlighting. Esc already does nothing useful in normal mode.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Close the buffer but keep the window layout intact. Plain :bdelete also
-- closes the window when that buffer was the only thing in it; :bprevious first
-- leaves the window pointing at something else.
map("n", "<leader>bd", function()
	local buf = vim.api.nvim_get_current_buf()
	vim.cmd("bprevious")
	vim.api.nvim_buf_delete(buf, { force = false })
end, { desc = "Delete buffer, keep the window" })

-- Esc twice leaves terminal insert mode. Without this, Esc goes to the shell
-- running inside the terminal buffer and there is no way back to normal mode.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- Keep the cursor centred when jumping half a page, so the eye does not have to
-- re-find it.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Move the selected lines up and down, re-indenting as they go.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the yanked text when pasting over a selection. The default puts the
-- replaced text in the unnamed register, so pasting the same thing twice fails.
map("v", "p", '"_dP', { desc = "Paste without clobbering the register" })
