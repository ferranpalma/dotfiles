# dotfiles

This repo contains a terminal setup on macOS. It follows the [XDG Base Directory spec](https://specifications.freedesktop.org/basedir/latest/).
This is in order to keep `$HOME` as clean as possible as well as following the best practices.
The only file left in `$HOME` is `~/.zshenv` (apart from the dot directories that cannot be moved, such as `~/.ssh`), which sets `ZDOTDIR` so zsh reads everything else from `~/.config/zsh/`.

## Tech stack

- Shell: zsh
- Package manager: brew
- Runtime manager: mise (also installs nvim's language servers and formatters)
- Text editor: nvim. Anything about nvim (keymaps, plugins, LSP, how its config
  is organised): read `nvim/CLAUDE.md` first.
- Other: tmux (default prefix `C-b`)

## Project structure

The repo must live at `~/dotfiles`: the zsh files source each other with literal
`~/dotfiles/...` paths. Files are symlinked into place by `bootstrap`, so an
edit here is live, but only once it is re-read: a new shell, `prefix r` in tmux,
or restarting nvim.

| In the repo | Linked to | Purpose |
| --- | --- | --- |
| `.zshenv` | `~/.zshenv` and `~/.config/zsh/.zshenv` | XDG variables, `ZDOTDIR`; exports only |
| `.zprofile` | `~/.config/zsh/.zprofile` | `PATH`, Homebrew, mise shims, `EDITOR` |
| `.zshrc` | `~/.config/zsh/.zshrc` | interactive shell: history, completion, prompt |
| `.zsh_xdg_compliant` | sourced by `.zshenv` | per-tool variables that keep files out of `$HOME` |
| `.zsh_xdg_dirs` | sourced by `.zshrc` | creates the directories those variables point to |
| `.zsh_alias`, `.zsh_functions`, `.zsh_plugins` | sourced by `.zshrc` | aliases, functions, zplug plugins |
| `.tmux.conf` | `~/.config/tmux/tmux.conf` | tmux, plugins through tpm |
| `nvim/` | `~/.config/nvim` | nvim keymaps, plugins and configuration |
| `git/config` | `~/.config/git/config` | git; there is no `~/.gitconfig` |
| `mise.toml` | `~/.config/mise/config.toml` | runtimes, language servers, formatters |
| `Brewfile` | found through `HOMEBREW_BUNDLE_FILE` | programs this machine runs |
| `bin/*` | `~/.local/bin/` | scripts run by the launchd agents |
| `launchd/*.plist` | `~/Library/LaunchAgents/` | launchd agents definition |


## Commands

- `zsh -n <file>`: syntax-check a zsh file or the bootstrap script
- `~/dotfiles/bootstrap`: idempotent command to set up a new machine. Always ask
  before running it.

## Conventions

- A setting, mapping or plugin is only added when the default is not enough or there is a major upgrade using it.
- Nothing is upgraded by default. A explicit user command is needed (`brew upgrade`, `mise upgrade`, `:Lazy update`, or `brew bundle`, which upgrades too).
- Every new config file has to exist in the repo.
- Programs the machine runs go in the `Brewfile`. Toolchain (runtimes, language servers, formatters) goes in `mise.toml`.
- Every directly installed brew package has to be listed in the `Brewfile`.
- A plist's label ends in the name of its script in `bin/`
(`com.ferranpalmac.brew-outdated` runs `bin/brew-outdated`); `bootstrap`
discovers every plist in `launchd/`, so adding an agent is adding those two
files. The launchd scripts in `bin/` run with an almost empty environment,
write a cache under `$XDG_STATE_HOME`, and the matching `*_outdated_notice`
function in `.zsh_functions` only reads that cache, so new shells make no
network call.
- Each zsh file header says why things are where they are, and
the reasons are macOS-specific: `PATH` goes in `.zprofile` because
`/etc/zprofile` rebuilds it, and `HISTFILE` goes in `.zshrc` because `/etc/zshrc`
sets it. `.zshenv` only exports: no output, nothing slow.
- Nothing private is committed: keys and `*.local` files are in `.gitignore`.
- Commits: one short lowercase subject line, no prefix. They are SSH-signed (`git/config`).


## Instructions

- Every file a tool reads from a fixed path needs a `link` line in step 4 of
  `bootstrap`. Not the files that are sourced (`.zsh_*`), not the `Brewfile`
  (found through `HOMEBREW_BUNDLE_FILE`), and not `bin/` or `launchd/`, which
  step 6 links on its own.
- If a tool insists on writing to `$HOME`, find its environment
variable and set it in `.zsh_xdg_compliant`; add the directory to
`.zsh_xdg_dirs` if the tool does not create it.
- Any question about anything related to the tools defined in this repo (keymaps, config...) has to be validated against the actual repo. If anything is not explicitly defined, fallback to the defaults for the tool, checked against the installed source or `--help` rather than from memory or from comments.
- Do not propose a new mapping or plugin when a default already does the job;
  mention the default, and offer the change only as an option.
