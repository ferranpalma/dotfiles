# nvim

Neovim config, linked as a whole to `~/.config/nvim`. Requires nvim >= 0.11
(native `vim.lsp.config()` / `vim.lsp.enable()`).

## Answering questions about keys

- Leader is `<space>`.
- Non-plugin keymaps, and the built-in defaults worth knowing, are in
  `lua/ferran/core/keymaps.lua`.
- A plugin's keymaps are in the `keys` table (or `on_attach`) of that plugin's
  file in `lua/ferran/plugins/`.
- LSP keys are all nvim built-ins, listed in the header of `lua/ferran/lsp/init.lua`.
- When nothing is mapped, the answer is the plugin's default. Check it in the
  installed source, `~/.local/share/nvim/lazy/<plugin>/`, not in comments here:
  comments describing plugin defaults have been wrong before.

## Structure

- Every module lives under `lua/ferran/`, so none can collide with a plugin's.
- `init.lua` loads `core` (options, then keymaps), then `lazy`, then `lsp`.
  Order matters: the leader must be set before lazy registers plugin keys.
- **Plugins:** one file per plugin in `lua/ferran/plugins/`, returning its
  lazy.nvim spec, keymaps included. lazy imports the whole directory, so adding
  a plugin is adding a file and removing it is deleting the file. `mini.lua`
  holds two plugins because neither needs configuration.
- **Language servers:** one file per server in `lua/ferran/lsp/servers/`,
  named after the server and returning its config. They are discovered, not
  listed. The server's binary goes in `../mise.toml`, never in the Brewfile.
- **Formatters:** `lua/ferran/plugins/conform.lua`, format on save, LSP as the
  fallback. Formatter binaries also go in `mise.toml`.

## Conventions

- Native features over plugins. There is deliberately no nvim-lspconfig, no
  Mason and no nvim-cmp/blink: servers use the native API, completion is
  `vim.lsp.completion`, and tools are installed by mise.
- Defaults over remaps. A default worth knowing is documented in a comment in
  `core/keymaps.lua`, not remapped.
- `lazy-lock.json` is committed and changes only with `:Lazy update`, which is
  the user's call. lazy's update checker is off.
- treesitter is the `main` branch rewrite, not the old `master`; its parsers
  are listed in `lua/ferran/plugins/treesitter.lua`.
- Lua is formatted with stylua (tabs) on save.
- Every file starts with a comment saying why it exists and why it is built that
  way; keep it accurate when the behaviour changes.

## Checking a change

```zsh
nvim --headless +qa    # prints any error raised while loading the config
```

Inside nvim, `:checkhealth` and `:Lazy` show the state of the config and
plugins.
