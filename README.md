# dotfiles

My terminal setup on macOS: zsh, tmux and Neovim, following the
[XDG Base Directory spec](https://specifications.freedesktop.org/basedir/latest/)
to keep `$HOME` as clean as possible.

The only file left in `$HOME` is `~/.zshenv`, which sets `ZDOTDIR` so zsh reads
everything else from `~/.config/zsh/`.

## Setup

Clone into `~/dotfiles` — exactly there, since the files source each other with
literal `~/dotfiles/...` paths — and run `bootstrap`:

```zsh
git clone <repo-url> ~/dotfiles
~/dotfiles/bootstrap
```

The script is safe to rerun and it does the following things (unless other is specified with flags):

- Installs Homebrew if missing.
- Installs the packages defined in the `Brewfile`.
- Installs zplug and tpm (tmux plugin manager).
- Creates all the required symlinks.
- Installs the mise runtimes and language servers.
- Creates two launchd agents.
- Installs the tmux and nvim plugins and compiles the treesitter parsers.

An existing real file is never overwritten, only renamed to `.backup-<timestamp>`.

```zsh
~/dotfiles/bootstrap --no-plugins   # skip the slow tmux/nvim plugin steps
~/dotfiles/bootstrap --help
```

Then open a new terminal — zplug installs its own plugins on that first start.

## What is in here

| | |
|---|---|
| `.zshenv` | XDG variables, `ZDOTDIR`, locale. Read by every zsh |
| `.zprofile` | `PATH`, Homebrew, mise shims, `EDITOR`. Login shells |
| `.zshrc` | history, completion, prompt, and the files below. Interactive shells |
| `.zsh_xdg_compliant` | per-tool variables that move config out of `$HOME` |
| `.zsh_xdg_dirs` | creates the directories those variables point at |
| `.zsh_alias`, `.zsh_functions`, `.zsh_plugins` | aliases, functions, zplug plugins |
| `.tmux.conf` | tmux settings, key bindings and tpm plugins |
| `nvim/` | Neovim config. |
| `Brewfile` | the Homebrew packages |
| `mise.toml` | toolchains, runtime versions and nvim language servers |
| `bin/` | `brew-outdated` and `mise-outdated` jobs |
| `launchd/` | agent definitions |
| `bootstrap` | the setup script |

## Day to day

```zsh
brew bundle                 # install anything missing from the Brewfile
brew bundle cleanup         # list installed packages the Brewfile does not have
mise install                # install anything missing from mise.toml
mise outdated / upgrade     # updates
```

Neither `brew bundle` nor `mise install` ever upgrades. Two launchd agents, one
per tool, check once a day, and the first shell of the day prints what is behind:

```
brew 3 outdated: ca-certificates libuv utf8proc (brew upgrade)
mise 2 outdated: gopls ruff (mise upgrade)
```

## Notes

- Homebrew installs programs this machine runs; mise installs the toolchain the
  code needs.
- `.zshenv` is linked twice, to `~/` and to `~/.config/zsh/`. zsh reads the first
  when `ZDOTDIR` is unset and the second when it is, so without both a nested
  shell would only inherit the variables instead of re-reading them.
