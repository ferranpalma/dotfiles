-- Entry point. The whole directory is linked to ~/.config/nvim.
--
-- Nothing here redirects paths: nvim is XDG-native on its own. It reads
-- $XDG_CONFIG_HOME/nvim and writes to $XDG_DATA_HOME/nvim (plugins, parsers),
-- $XDG_STATE_HOME/nvim (undo, shada) and $XDG_CACHE_HOME/nvim. That is why
-- there is no nvim section in .zsh_xdg_compliant.
--
-- Everything lives under lua/ferran/ rather than lua/ directly, so that a
-- module of this config can never collide with one shipped by a plugin: a
-- plugin with its own lua/core/ or lua/plugins/ would otherwise shadow, or be
-- shadowed by, ours depending on runtimepath order.
--
-- Order matters. core comes first because it sets the leader key, which
-- lazy.nvim must already know when it registers plugin mappings; lsp comes
-- last because it only reacts to servers attaching.

require("ferran.core")
require("ferran.lazy")
require("ferran.lsp")
