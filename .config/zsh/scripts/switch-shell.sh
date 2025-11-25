#!/data/data/com.termux/files/usr/bin/bash
# Interactive switch-shell for Termux using fzf

PROFILE="$HOME/.bash_profile"
BACKUP="$HOME/.bash_profile.backup"

ensure_backup() {
    if [ ! -f "$BACKUP" ]; then
        cp "$PROFILE" "$BACKUP" 2>/dev/null
    fi
}

enable_zsh() {
    ensure_backup
    sed -i '/exec zsh/d' "$PROFILE" 2>/dev/null
    printf '\n# Auto-start Zsh\n[ -t 1 ] && exec zsh\n' >> "$PROFILE"
    echo "✓ Zsh is now the default shell."
}

disable_zsh() {
    ensure_backup
    sed -i '/exec zsh/d' "$PROFILE" 2>/dev/null
    echo "✓ Bash restored as the default shell."
}

restore_backup() {
    if [ -f "$BACKUP" ]; then
        cp "$BACKUP" "$PROFILE"
        echo "✓ Restored .bash_profile from backup."
    else
        echo "× No backup available."
    fi
}

status() {
    if grep -q "exec zsh" "$PROFILE" 2>/dev/null; then
        echo "Current default shell: Zsh"
    else
        echo "Current default shell: Bash"
    fi
}

# --- Interactive selection using fzf ---
menu() {
    OPTIONS=$(
        printf "Set Zsh as default\nSet Bash as default\nView current status\nRestore backup\nExit"
    )

    CHOICE=$(echo "$OPTIONS" | fzf --prompt="switch-shell › " --height=40% --layout=reverse)

    case "$CHOICE" in
        "Set Zsh as default") enable_zsh ;;
        "Set Bash as default") disable_zsh ;;
        "View current status") status ;;
        "Restore backup") restore_backup ;;
        *) exit 0 ;;
    esac
}

# run non-interactive mode if arguments provided
case "${1:-}" in
    "zsh") enable_zsh ;;
    "bash") disable_zsh ;;
    "status") status ;;
    "restore") restore_backup ;;
    "") menu ;;
    *) echo "Usage: switch-shell {zsh|bash|status|restore}" ;;
esac

