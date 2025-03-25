#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

# shellcheck source=/dev/null
if [ -n "$BASH_VERSION" ]; then
  SOURCE_CMD="source"
elif [ -n "$ZSH_VERSION" ]; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/utils.sh"

main() {
  log "Starting system setup..."

  run_setup "mac"
  run_setup "fonts"
  run_setup "xcode"
  run_setup "homebrew"
  run_setup "git"
  run_setup "tmux"
  run_setup "starship"
  run_setup "asdf"
  run_setup "zsh"

  log "System setup completed successfully"
}

main
