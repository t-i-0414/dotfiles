#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
FONT_DIR="$HOME/Library/Fonts"

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
  if [ ! -d "$FONT_DIR" ]; then
    log "Error: Font directory $FONT_DIR not found"
    return 1
  fi

  if ! compgen -G "$THIS_DIR/*.ttf" >/dev/null; then
    log "Error: No .ttf files found in $THIS_DIR"
    return 1
  fi
}

install_fonts() {
  log "Installing fonts to $FONT_DIR..."

  for file in "$THIS_DIR"/*.ttf; do
    cp -v "$file" "$FONT_DIR"
  done

  log "Installation complete."
}

main() {
  check_requirements || exit 1
  install_fonts || exit 1
}

main
