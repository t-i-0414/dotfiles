#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

# shellcheck source=/dev/null
source "${THIS_DIR}/../utils.sh"

DOTFILES=(.gitconfig .gitignore)

check_requirements() {
  for file in "${DOTFILES[@]}"; do
    if [ ! -f "$THIS_DIR/$file" ]; then
      log "Error: $file not found in $THIS_DIR"
      return 1
    fi
  done
}

install_dotfiles() {
  for file in "${DOTFILES[@]}"; do
    ln -snfv "$THIS_DIR/$file" "$HOME/$file"
  done
  log "Dotfiles linked to home directory."
}

main() {
  check_requirements || exit 1
  install_dotfiles || exit 1
}

main
