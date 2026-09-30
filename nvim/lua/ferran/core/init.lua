-- Everything that is nvim itself rather than a plugin. Required as a whole by
-- init.lua, so the two halves stay one unit: options first, because keymaps.lua
-- assumes the leader key is already set.

require("ferran.core.options")
require("ferran.core.keymaps")
