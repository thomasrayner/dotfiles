#!/usr/bin/env bash

set -euo pipefail

SEARCH_DIRS=("$HOME/git" "$HOME/personal")
PANE_ID=$(tmux display -p '#{pane_id}')

FILES=$(find "${SEARCH_DIRS[@]}" \
  -path '*/.git' -prune -o \
  -type f -printf '%T@ %p\n' 2>/dev/null |
  sort -nr | cut -d' ' -f2- | head -n 200 || true)

if [ -z "$FILES" ]; then
  exit 0
fi

MENU=$(echo "$FILES" | while read -r full; do
  label=$(echo "$full" | awk -F/ '{n=NF; print $(n-2) "/" $(n-1) "/" $n}')
  printf "%-40s │ %s\n" "$label" "$full"
done)

set +e
SELECTED=$(echo "$MENU" | fzf \
  --prompt="Recent files > " \
  --preview="bat --style=numbers --color=always --line-range=:500 {2}" \
  --with-nth=1 \
  --delimiter="│" \
  --height=70% --layout=reverse \
  --tmux=right,95%,95%)
FZF_EXIT=$?
set -e

if [ "$FZF_EXIT" -ne 0 ] || [ -z "$SELECTED" ]; then
  exit 0
fi

FULL_PATH=$(echo "$SELECTED" | cut -d'│' -f2- | sed 's/^ *//')

if [ -z "$FULL_PATH" ]; then
  exit 0
fi

CMD="nvim \"$FULL_PATH\""
tmux send-keys -t "$PANE_ID" "$CMD" C-m
