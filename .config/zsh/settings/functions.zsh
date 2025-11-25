# ~/.config/zsh/settings/functions.zsh
# ----------------------------------------------------
# Zsh Functions (Termux-Optimized)
# ----------------------------------------------------

# ----------------------------------------------------
# Switch default shell between zsh and bash
# ----------------------------------------------------
switch-shell() {
    command "$HOME/.config/zsh/scripts/switch-shell.sh" "$@"
}

# ----------------------------------------------------
# Update autosuggest & syntax-highlighting
# ----------------------------------------------------

update-plugins() {
    command "$HOME/.config/zsh/scripts/update-plugins.sh" "$@"
}

# ----------------------------------------------------
# Autosuggest and Syntax-highling update
# ----------------------------------------------------
#update-plugins() {
	# command "$HOME/.config/zsh/scripts/update-plugins.sh" "$@"
  #   }

# ----------------------------------------------------
# Safe rm → move files to ~/.trash
# ----------------------------------------------------
trash() {
    mkdir -p ~/.trash
    for f in "$@"; do
        [[ -e "$f" ]] \
            && mv "$f" ~/.trash/ && echo "Moved '$f' to ~/.trash" \
            || echo "trash: '$f' not found"
    done
}

# ----------------------------------------------------
# Extract various archive formats
# ----------------------------------------------------
extract() {
    [[ -z "$1" ]]      && { echo "Usage: extract <file>"; return 1; }
    [[ ! -f "$1" ]]    && { echo "extract: File not found: $1"; return 1; }

    case "$1" in
        *.tar.gz|*.tgz) tar -xvzf "$1" ;;
        *.tar.bz2)      tar -xvjf "$1" ;;
        *.tar.xz)       tar -xvJf "$1" ;;
        *.zip)          unzip -q "$1" ;;
        *.rar)          unrar x "$1" ;;
        *.7z)           7z x "$1" ;;
        *) echo "extract: Unknown format: $1" ;;
    esac
}

# ----------------------------------------------------
# mkdir + cd
# ----------------------------------------------------
mkcd() {
    [[ -z "$1" ]] && { echo "mkcd: missing directory name"; return 1; }
    mkdir -p "$1" && cd "$1"
}

# ----------------------------------------------------
# Create file + parent dir + open in EDITOR
# ----------------------------------------------------
mkfile() {
    [[ -z "$1" ]] && { echo "mkfile: provide a file path"; return 1; }

    mkdir -p "$(dirname "$1")" &&
    : > "$1" &&
    "$EDITOR" "$1"
}

# ----------------------------------------------------
# cdf → cd to dirname of file OR fuzzy directory search
# ----------------------------------------------------
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


# ----------------------------------------------------
# cdff → fuzzy directory jump with preview
# ----------------------------------------------------
cdff() {
    local dir
    dir=$(
        _fzf_find -type d 2>/dev/null |
        fzf --height=40% --reverse \
            --preview="ls -a {}"
    )

    [[ -n "$dir" ]] && cd "$dir"
}

# ----------------------------------------------------
# fsearch → recursive search (rg → grep fallback)
# ----------------------------------------------------
fsearch() {
    [[ -z "$1" ]] && { echo "fsearch: provide a search pattern"; return 1; }

    if command -v rg >/dev/null 2>&1; then
        rg --hidden --smart-case "$@"
    else
        grep -R --color=auto "$@" .
    fi
}

# ----------------------------------------------------
# ffsearch → fuzzy-pick search match → open in nvim
# ----------------------------------------------------
ffsearch() {
    local query="$1"
    [[ -z "$query" ]] && { echo "Usage: ffsearch <pattern>"; return 1; }

    local results
    if command -v rg >/dev/null 2>&1; then
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

# ----------------------------------------------------
# Fast grep (simple, recursive)
# ----------------------------------------------------
f() {
    grep -Rni --exclude-dir={.git,node_modules} "$1" .
}

# ----------------------------------------------------
# fd → fuzzy directory jump
# ----------------------------------------------------
fd() {
    local dir
    dir=$(_fzf_find -type d 2>/dev/null | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}

# ----------------------------------------------------
# ff → fuzzy file finder (prints path)
# ----------------------------------------------------
fs() {
    local file
    file=$(_fzf_find -type f 2>/dev/null | fzf)
    [[ -n "$file" ]] && echo "$file"
}

# ----------------------------------------------------
# fff → fuzzy file finder with preview + smart opener
# ----------------------------------------------------
ff() {
    local file
    file=$(
        _fzf_find -type f 2>/dev/null |
      #fzf --preview="bat --color=always {} 2>/dev/null || head -50 {}"
      fzf --height=70%
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


# ----------------------------------------------------
# Compact history view
# ----------------------------------------------------
history-small() {
    local n=${1:-20}
    history | tail -n "$n"
}

# ----------------------------------------------------
# Show local IP addresses
# ----------------------------------------------------
iplocal() {
    ip -o addr show 2>/dev/null |
        awk '$3=="inet"{print $4}'
}

# ----------------------------------------------------
# Clear command hash cache
# ----------------------------------------------------
fixpath() {
    hash -r
}

# ----------------------------------------------------
# cd wrapper → zoxide integration
# ----------------------------------------------------
cd() {
    [[ $# -eq 0 ]] && z || z "$@"
}

# ----------------------------------------------------
# pastefile → clipboard → file
# ----------------------------------------------------
pastefile() {
    [[ -z "$1" ]] && { echo "pastefile: provide a target file"; return 1; }

    termux-clipboard-get > "$1" &&
    echo "Clipboard saved to: $1"
}

# ----------------------------------------------------
# copyfile → file → clipboard
# ----------------------------------------------------
copyfile() {
    [[ ! -f "$1" ]] && { echo "copyfile: file does not exist: $1"; return 1; }

    termux-clipboard-set < "$1" &&
    echo "Copied: $1"
}
