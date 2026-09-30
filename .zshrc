# Loaded by interactive shells after .zprofile

# Must be in this file: macOS's /etc/zshrc (loaded just before this one) sets
# HISTFILE too, so setting it in .zshenv or .zprofile would be overwritten.
# Must be before .zsh_xdg_dirs, which uses it to create the history folder.
export HISTFILE="$XDG_STATE_HOME/zsh/history"

source ~/dotfiles/.zsh_xdg_dirs
source ~/dotfiles/.zsh_functions
source ~/dotfiles/.zsh_alias
source ~/dotfiles/.zsh_plugins

export HISTSIZE=50000                           
export SAVEHIST=10000                           

setopt extended_history                         
setopt hist_expire_dups_first                   
setopt hist_ignore_dups                         
setopt hist_ignore_space                        
setopt hist_verify                              
setopt share_history                            

# compinit is already run by `zplug load` (dump at $ZPLUG_HOME/zcompdump)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu on                           
zstyle ':completion:*' list-colors ""                    

# Runtime versions for interactive shells: a hook that rewrites PATH on cd, so
# `which node` is the real binary rather than a shim. Replaces the shims that
# .zprofile put on PATH.
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

eval "$(starship init zsh)"

# Defined in .zsh_functions
brew_outdated_notice
mise_outdated_notice
