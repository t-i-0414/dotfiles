#!/bin/bash
# Claude Code status line script
# Matches tonkotsuboy_com's setup

input=$(cat)

# --- Line 1: Current folder path with emoji ---
cwd=$(echo "$input" | jq -r '.cwd // empty')
if [ -z "$cwd" ]; then
  cwd=$(pwd)
fi
# Shorten home directory to ~
folder_path="${cwd/#$HOME/\~}"

# --- Line 2: Repository name | Branch name with emojis ---
repo_line=""
if git_root=$(git -C "${cwd}" rev-parse --show-toplevel 2>/dev/null); then
  repo_name=$(basename "$git_root" 2>/dev/null)
  branch=$(git -C "${cwd}" symbolic-ref --short HEAD 2>/dev/null || git -C "${cwd}" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$repo_name" ] && [ -n "$branch" ]; then
    repo_line="🐙 ${repo_name} | 🌿 ${branch}"
  elif [ -n "$repo_name" ]; then
    repo_line="🐙 ${repo_name}"
  fi
fi

# --- Line 3: Context usage with progress bar | Model ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_line=""
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct" 2>/dev/null || echo "0")
  # Build progress bar (20 chars wide)
  bar_width=20
  filled=$(( used_int * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  bar=""
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty; i++)); do bar+="░"; done
  context_line="🧠 ${bar} ${used_int}%"
fi

# --- Line 4+: ccusage (remove 🧠 context part to avoid duplication with line 3) ---
ccusage_line=""
if command -v ccusage >/dev/null 2>&1; then
  ccusage_line=$(echo "$input" | ccusage statusline 2>/dev/null || true)
elif command -v bunx >/dev/null 2>&1; then
  ccusage_line=$(echo "$input" | bunx ccusage statusline 2>/dev/null || true)
elif command -v npx >/dev/null 2>&1; then
  ccusage_line=$(echo "$input" | npx ccusage statusline 2>/dev/null || true)
fi
# Filter ccusage output: keep session cost + block remaining time only
if [ -n "$ccusage_line" ]; then
  session=$(echo "$ccusage_line" | grep -o '\$[0-9.]*[[:space:]]*session' || true)
  block_time=$(echo "$ccusage_line" | grep -o '([0-9h ]*[0-9m]*[[:space:]]*left)' || true)
  parts=""
  [ -n "$session" ] && parts="💰 ${session}"
  [ -n "$block_time" ] && parts="${parts:+$parts | }⏳ ${block_time}"
  ccusage_line="$parts"
fi

# --- Build output ---
output="📁 ${folder_path}"

if [ -n "$repo_line" ]; then
  output="${output}\n${repo_line}"
fi

if [ -n "$context_line" ]; then
  output="${output}\n${context_line}"
fi

if [ -n "$ccusage_line" ]; then
  output="${output}\n${ccusage_line}"
fi

printf "%b" "$output"
