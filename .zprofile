# Loaded by login shells (every new macOS terminal tab).
# PATH changes must be in this file: macOS's /etc/zprofile (loaded just before
# this one) rebuilds PATH, so changes made in .zshenv would end up behind
# the system folders.

export PATH="$HOME/.local/bin:$PATH"

# In macOS, add homebrew to path
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# Must be after homebrew: mise is installed with it.
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh --shims)"
fi

# Should be after homebrew: nvim is installed with it, so it's not on PATH before
if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
elif command -v vim &> /dev/null; then
  export EDITOR="vim"
  export VISUAL="vim"
else
  export EDITOR="vi"
  export VISUAL="vi"
fi
