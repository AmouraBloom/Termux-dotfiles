autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# Force Emacs keybindings (disable VI mode entirely)
bindkey -e
export KEYMAP=emacs
