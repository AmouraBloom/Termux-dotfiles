# ~/.config/zsh/.zshrc
# ----------------------------------------------------
# INTERACTIVE ZSH SETUP
# ----------------------------------------------------

# Exit early if shell is not interactive
[[ $- != *i* ]] && return


# ----------------------------------------------------
# SETTINGS (History, Aliases, Keybinds, Functions)
# ----------------------------------------------------
source "$ZDOTDIR/settings/history.zsh"
source "$ZDOTDIR/settings/aliases.zsh"
source "$ZDOTDIR/settings/keybinds.zsh"
source "$ZDOTDIR/settings/functions.zsh"


# ----------------------------------------------------
# COMPLETIONS
# ----------------------------------------------------
if [[ -d "$ZDOTDIR/completions" ]]; then
    fpath+=("$ZDOTDIR/completions")
fi


# ----------------------------------------------------
# PLUGINS
# ----------------------------------------------------
for plugin in "$ZDOTDIR"/plugins/*/*.zsh; do
    source "$plugin"
done


# ----------------------------------------------------
# FZF INTEGRATION
# ----------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# Filtered find used only for fzf pipelines
_fzf_find() {
    command find . \
        \( -path "./.cache" -o -path "./.git" -o -path "./node_modules" \) -prune -o \
        "$@"
}


# ----------------------------------------------------
# ZOXIDE (Smart cd)
# ----------------------------------------------------
eval "$(zoxide init zsh)"


# ----------------------------------------------------
# STARSHIP PROMPT
# ----------------------------------------------------
eval "$(starship init zsh)"

