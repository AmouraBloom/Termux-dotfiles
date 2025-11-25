# ~/.config/zsh/.zprofile
# ----------------------------------------------------
# LOGIN-SHELL SETTINGS (rarely used in Termux)
# ----------------------------------------------------

# Start SSH agent only during real login shells
if [[ -z "$TERMUX_VERSION" ]]; then
  if command -v ssh-agent >/dev/null 2>&1; then
    if ! pgrep -u "$UID" ssh-agent >/dev/null 2>&1; then
      eval "$(ssh-agent -s)" >/dev/null 2>&1
    fi
  fi
fi

# Always begin login sessions in $HOME
cd "$HOME"
