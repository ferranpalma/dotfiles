# Loaded by every zsh before any other file.
# Only exports here: no output, no aliases, nothing slow.

# XDG specification https://specifications.freedesktop.org/basedir/latest/
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"

# zsh reads the rest of its files (.zprofile, .zshrc) from here
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Per-tool variables to keep their files out of $HOME
source ~/dotfiles/.zsh_xdg_compliant
