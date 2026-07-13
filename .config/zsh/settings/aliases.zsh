# ----------------------------------------------------
# Aliases
# Clean • Consistent • Termux-Optimized
# ----------------------------------------------------

# Basics
alias cls='clear'
alias vim='nvim'

# ----------------------------------------------------
# eza (ls replacement)
# ----------------------------------------------------
alias ls='eza -al --header --color=always --icons --group-directories-first'
alias lt='eza -aT --color=always --icons --group-directories-first'
alias l.='eza -a | egrep "^\."'

# ----------------------------------------------------
# Colored grep
# ----------------------------------------------------
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

# ----------------------------------------------------
# Termux package helpers
# ----------------------------------------------------
alias update='pkg --check-mirror update'
alias upgrade='apt upgrade -y'
alias search='pkg search'
alias autoremove='apt autoremove -y'
alias clean='pkg clean'

# ----------------------------------------------------
# Navigation shortcuts
# ----------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias -- -='cd -'   # cd back

# ----------------------------------------------------
# Termux storage shortcuts
# (after running: termux-setup-storage)
# ----------------------------------------------------
alias sd='cd /sdcard'
alias dl='cd /sdcard/Download'

# ----------------------------------------------------
