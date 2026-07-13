# =====================================================================
#                          B A S H R C   ( T E R M U X )
# =====================================================================
# Clean, consistent, organized, and mobile-optimized
# =====================================================================

# ---------------------------------------------------------------------
# Environment & PATH
# ---------------------------------------------------------------------

# Termux PREFIX is sacred; prepend safely
if [ -d "$HOME/bin" ] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    PATH="$HOME/bin:$PATH"
fi
export PATH

export EDITOR="nvim"
export PAGER="less"
export LESS='-R'

# Shared history between Bash & Zsh
HISTFILE="$HOME/.shared_history"
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=50000
export HISTFILESIZE=100000
shopt -s histappend

# Sync history after each command (Termux-friendly)
PROMPT_COMMAND='history -a; history -c; history -r'


# =====================================================================
#                               Prompt
# =====================================================================

eval "$(starship init bash)"


# =====================================================================
#                                Aliases
# =====================================================================

alias cls='clear'
alias vim='nvim'

# eza (ls replacement)
alias ls='eza -al --header --color=always --icons --group-directories-first'
alias lt='eza -aT --color=always --icons --group-directories-first'
alias l.='eza -a | egrep "^\."'

# Grep colors
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

# Termux package helpers
alias update='pkg --check-mirror update'
alias upgrade='apt upgrade -y'
alias search='pkg search'
alias autoremove='apt autoremove -y'
alias clean='pkg clean -y'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias -- -='cd -'

# Storage shortcuts (after termux-setup-storage)
alias sd='cd /sdcard'
alias dl='cd /sdcard/Download'


# =====================================================================
#                       zoxide (smart cd replacement)
# =====================================================================

cd() {
    if [[ $# -eq 0 ]]; then
        z
    else
        z "$@"
    fi
}

eval "$(zoxide init bash)"


# =====================================================================
#                               Functions
# =====================================================================

# Switch between Bash ↔ Zsh
switch-shell() {
    command "$HOME/.config/zsh/scripts/switch-shell.sh" "$@"
}

# Filtered find used only for fzf pipelines

_fzf_find() {
    command find . \
        \( -path "./.cache" -o -path "./.git" -o -path "./node_modules" \) -prune -o \
        "$@"
}


# Safe trash wrapper (instead of rm)
trash() {
    mkdir -p ~/.trash
    for f in "$@"; do
        if [[ -e "$f" ]]; then
            mv "$f" ~/.trash/
            echo "Moved '$f' → ~/.trash"
        else
            echo "trash: '$f' not found"
        fi
    done
}

# Extract archives
extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <file>"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "extract: File not found: $1"
        return 1
    fi

    case "$1" in
        *.tar.gz|*.tgz)  tar -xvzf "$1" ;;
        *.tar.bz2)       tar -xvjf "$1" ;;
        *.tar.xz)        tar -xvJf "$1" ;;
        *.zip)           unzip -q "$1" ;;
        *.rar)
            command -v unrar >/dev/null || { echo "install unrar"; return 1; }
            unrar x "$1"
            ;;
        *.7z)
            command -v 7z >/dev/null || { echo "install p7zip"; return 1; }
            7z x "$1"
            ;;
        *) echo "extract: Unknown format: $1" ;;
    esac
}

# Search text recursively (ripgrep → grep fallback)
fsearch() {
    [[ -z "$1" ]] && { echo "fsearch: provide a pattern"; return 1; }

    if command -v rg >/dev/null; then
        rg --hidden --smart-case "$@"
    else
        grep -R --color=auto "$@" .
    fi
}

# Create a file and open it
mkfile() {
    [[ -z "$1" ]] && { echo "mkfile: provide a file path"; return 1; }
    mkdir -p "$(dirname "$1")" &&
    : > "$1" &&
    "$EDITOR" "$1"
}

# Save clipboard → file
pastefile() {
    [[ -z "$1" ]] && { echo "pastefile: provide a file"; return 1; }
    termux-clipboard-get > "$1"
    echo "Clipboard saved → $1"
}

# Copy file → clipboard
copyfile() {
    [[ ! -f "$1" ]] && { echo "copyfile: file not found"; return 1; }
    termux-clipboard-set < "$1"
    echo "Copied: $1"
}

# mkdir + cd
mkcd() {
    [[ -z "$1" ]] && { echo "mkcd: missing dir name"; return 1; }
    mkdir -p "$1" && cd "$1"
}

# cdf: cd into dirname of file, or fuzzy directory picker
cdf() {

    # Case 1: path provided → cd to its directory
    if [[ -n "$1" ]]; then
        cd "$(dirname "$1")" 2>/dev/null || {
            echo "cdf: cannot cd into dirname of '$1'"
            return 1
        }
        return
    fi

    # Case 2: fuzzy directory search
    command -v fzf >/dev/null 2>&1 || {
        echo "cdf: fzf not installed"
        return 1
    }

    local dir
    dir=$(
        _fzf_find -type d 2>/dev/null |
        fzf --height=70% --reverse
    ) || return

    cd "$dir"
}

# cdff: fuzzy directory chooser with preview
cdff() {
    local dir
    dir=$(
        _fzf_find -type d 2>/dev/null |
        fzf --height=40% --reverse \
            --preview="ls -a {}"
    )

    [[ -n "$dir" ]] && cd "$dir"
}

# Fast grep
f() { grep -Rni --exclude-dir={.git,node_modules} "$1" .; }

# Compact history
history-small() {
    local n=${1:-20}
    history | tail -n "$n"
}

# Local IP
iplocal() { ip -o addr show 2>/dev/null | awk '$3=="inet"{print $4}'; }

# Clear command hash cache
fixpath() {
    hash -r
    echo "Command hash cache cleared."
}


# =====================================================================
#                           fzf-powered tools
# =====================================================================


# Ctrl-R: fuzzy search through history
fzf-history-widget() {
    READLINE_LINE=$(history | fzf | sed 's/ *[0-9]* *//')
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-r": fzf-history-widget'

# Fuzzy directory
fd() {
    local dir
    dir=$(_fzf_find . -type d 2>/dev/null | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}

# Kill processes via fzf
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf | awk '{print $2}')
    [[ -n "$pid" ]] && kill -9 "$pid"
}

# Fuzzy file finder for file path
fs() {
    local file
    file=$(_fzf_find -type f 2>/dev/null | fzf)
    [[ -n "$file" ]] && echo "$file"
}

# Fuzzy file finder with preview → smart open
ff() {
    local file
    file=$(
        _fzf_find -type f 2>/dev/null |
        fzf --preview="bat --color=always {} 2>/dev/null || head -50 {}"
    )

    [[ -z "$file" ]] && return 1

    # If text → open in editor
    if file "$file" | grep -qi "text"; then
        nvim "$file"
        return
    fi

    # Attempt xdg-open
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$file" >/dev/null 2>&1 &
        return
    fi

    # Fallback: print path
    echo "$file"
}


# Search text → pick result with fzf → open in editor at that line
ffsearch() {
    local query="$1"
    [[ -z "$query" ]] && { echo "Usage: ffsearch <pattern>"; return 1; }

    local results
    if command -v rg >/dev/null; then
        results=$(rg --line-number --no-heading --color=always "$query")
    else
        results=$(grep -Rni --color=always "$query" .)
    fi

    [[ -z "$results" ]] && { echo "No matches found."; return 1; }

    local selected
    selected=$(
        printf "%s\n" "$results" |
        fzf --ansi \
            --delimiter=":" \
            --with-nth=1,2,3 \
            --preview="bat --style=numbers --color=always {1} --highlight-line {2}"
    )

    [[ -z "$selected" ]] && return 1

    local file line
    file=$(echo "$selected" | cut -d: -f1)
    line=$(echo "$selected" | cut -d: -f2)

    nvim "+$line" "$file"
}
