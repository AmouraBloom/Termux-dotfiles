# ~/.config/zsh/.zshenv
# ----------------------------------------------------
# GLOBAL ENVIRONMENT (loads for ALL Zsh sessions)
# ----------------------------------------------------

# Base config directory (ZDOTDIR)
export ZDOTDIR="$HOME/.config/zsh"


# ----------------------------------------------------
# PATH SETUP (Termux-friendly)
# ----------------------------------------------------
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Ensure unique PATH entries
typeset -U PATH


# ----------------------------------------------------
# DEFAULT PROGRAMS & LOCALE
# ----------------------------------------------------
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export PAGER="less"
