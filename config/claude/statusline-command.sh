#!/usr/bin/env bash
# Status line derived from the zsh "fino-time" oh-my-zsh theme:
#   user at host in ~/dir on branch  date - time
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir')
# Relative to the home directory (shown as ~) when under it, else absolute.
case "$cwd" in
  "$HOME") dir="~" ;;
  "$HOME"/*) dir="~/${cwd#"$HOME"/}" ;;
  *) dir="$cwd" ;;
esac

branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
  || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

sep=$(printf ' \033[38;5;239m|\033[0m ')
out=$(printf '\033[1;38;5;226m%s\033[0m' "$dir")

if [ -n "$branch" ]; then
  out="$out$sep$(printf '\033[38;5;40m%s\033[0m' "$branch")"
fi

# Model (lowercased, "Claude " prefix dropped) plus effort level if present
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"' \
  | sed 's/^[Cc]laude //' | tr '[:upper:]' '[:lower:]')
effort=$(echo "$input" | jq -r '.effort.level // empty')
out="$out$sep$(printf '\033[38;5;33m%s%s\033[0m' "$model" "${effort:+ $effort}")"

# Context size and utilization
tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$tokens" ]; then
  tokens_fmt=$(echo "$tokens" | sed -e ':a' -e 's/\([0-9]\)\([0-9]\{3\}\)\($\|,\)/\1,\2\3/;ta')
  out="$out$sep$(printf 'context: %s - %.0f%% utilization' "$tokens_fmt" "${pct:-0}")"
else
  out="$out${sep}context: 0 - 0% utilization"
fi

# Agent mode (only shown if Claude Code supplies it)
mode=$(echo "$input" | jq -r '.permission_mode // .mode // empty')
[ -n "$mode" ] && out="$out$sep$(printf '\033[38;5;202m%s\033[0m' "$mode")"

printf '%s' "$out"

