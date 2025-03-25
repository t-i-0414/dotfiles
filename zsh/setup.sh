#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES=(".hushlogin" ".zprofile" ".zshrc")

# shellcheck source=/dev/null
if [ -n "$BASH_VERSION" ]; then
  SOURCE_CMD="source"
elif [ -n "$ZSH_VERSION" ]; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD some_file.sh

check_requirements() {
  local missing_files=()

  for file in "${DOTFILES[@]}"; do
    if [ ! -f "$THIS_DIR/$file" ]; then
      missing_files+=("$file")
    fi
  done

  if [ ${#missing_files[@]} -ne 0 ]; then
    log "Error: Following files not found in $THIS_DIR:"
    printf '%s\n' "${missing_files[@]}"
    return 1
  fi
}

install_zsh_config() {
  for file in "${DOTFILES[@]}"; do
    ln -snfv "$THIS_DIR/$file" "$HOME/$file"
    log "Linked $file to $HOME"
  done
}

main() {
  check_requirements || exit 1
  install_zsh_config || exit 1
}

main
