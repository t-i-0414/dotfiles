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

$SOURCE_CMD some_file.sh

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
