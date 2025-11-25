#!/usr/bin/env bash

set -e

BASE="$HOME/.config/zsh/plugins"

URL_AUTOSUGGEST="https://github.com/zsh-users/zsh-autosuggestions"
URL_SYNTAX="https://github.com/zsh-users/zsh-syntax-highlighting"

TMP_AUTO="$BASE/autosuggest/tmp-clone"
TMP_SYN="$BASE/syntax-highlighting/tmp-clone"
REPO_SYN="$BASE/syntax-highlighting/repo"

echo "=== Updating zsh-autosuggestions ==="

rm -rf "$TMP_AUTO"
git clone --depth=1 "$URL_AUTOSUGGEST" "$TMP_AUTO"

# Autosuggest: only one file
cp "$TMP_AUTO/zsh-autosuggestions.zsh" \
   "$BASE/autosuggest/zsh-autosuggestions.zsh"

rm -rf "$TMP_AUTO"

echo "✔ autosuggest updated"


echo "=== Updating zsh-syntax-highlighting ==="

# Fresh clone
rm -rf "$TMP_SYN"
git clone --depth=1 "$URL_SYNTAX" "$TMP_SYN"

# Clear old repo folder (but keep plugin.zsh)
rm -rf "$REPO_SYN"
mkdir -p "$REPO_SYN"

# Copy required runtime files
cp "$TMP_SYN/zsh-syntax-highlighting.zsh" "$REPO_SYN/"
cp -r "$TMP_SYN/highlighters" "$REPO_SYN/"

# Metadata if available
cp "$TMP_SYN/.version" "$REPO_SYN/" 2>/dev/null || true
cp "$TMP_SYN/.revision-hash" "$REPO_SYN/" 2>/dev/null || true

rm -rf "$TMP_SYN"

echo "✔ syntax-highlighting updated"
echo "=== All plugins updated successfully ==="

