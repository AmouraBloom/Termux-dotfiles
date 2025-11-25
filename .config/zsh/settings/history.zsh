# ~/.config/zsh/settings/history.zsh

# Use shared history across Bash and Zsh
HISTFILE="$HOME/.shared_history"   # use $HOME for cross-shell portability
HISTSIZE=50000
SAVEHIST=100000

# Zsh history options
setopt append_history       # append new commands to the history file
setopt inc_append_history   # save each command immediately
setopt share_history        # share history across sessions
setopt hist_ignore_dups     # ignore duplicates
setopt hist_ignore_space    # ignore commands starting with space
setopt hist_verify          # show command before execution
