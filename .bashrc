# --------------------------------------
# Aliases
# --------------------------------------

alias cls='clear'
alias vim='nvim'

# eza replaces ls
alias ls='eza -al --header --color=always --icons --group-directories-first'
alias lt='eza -aT --color=always --icons --group-directories-first'
alias l.='eza -a | egrep "^\."'

# colored grep
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

# Termux package management
alias update='pkg update && pkg upgrade -y'
alias search='pkg search'
alias autoremove='apt autoremove -y'
alias autoclean='apt autoclean -y'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias -- -='cd -'

# Termux storage shortcuts after running termux-setup-storage
alias sd='cd /sdcard'
alias dl='cd /sdcard/Download'

# --------------------------------------
# Prompt
# --------------------------------------
eval "$(starship init bash)"

# --------------------------------------
# History Improvements
# --------------------------------------
shopt -s histappend
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T  "

# --------------------------------------
# Functions
# --------------------------------------

# extract archives easily
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.gz|*.tgz)  tar -xvzf "$1" ;;
            *.tar.bz2)       tar -xvjf "$1" ;;
            *.tar.xz)        tar -xvJf "$1" ;;
            *.zip)           unzip "$1" ;;
            *.rar)           unrar x "$1" ;;
            *) echo "Unsupported archive format" ;;
        esac
    else
        echo "File not found"
    fi
}

# mkdir + cd
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Fix Termux's "command not found until restart"
fixpath() {
    hash -r
    echo "Command hash cache cleared."
}

# --------------------------------------
# fzf (fuzzy finder)
# --------------------------------------

# Ctrl+R fuzzy history
fzf-history-widget() {
  READLINE_LINE=$(history | fzf | sed 's/ *[0-9]* *//')
  READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-r": fzf-history-widget'

# fuzzy file search
ff() {
    find . -type f | fzf
}

# --------------------------------------
# zoxide (smart cd)
# --------------------------------------
eval "$(zoxide init bash)"

# Make cd use zoxide automatically
alias cd='z'

# --------------------------------------
# Environment
# --------------------------------------

export EDITOR="nvim"
export PAGER="less"
export LESS='-R'
export PATH="$HOME/bin:$PATH"

