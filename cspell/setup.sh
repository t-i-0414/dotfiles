#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_FILE="cspell.json"
TARGET_DIR="$HOME/.config/cspell"

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../utils.sh"

check_requirements() {
  if [ ! -f "$THIS_DIR/$TARGET_FILE" ]; then
    log "Error: $TARGET_FILE not found in $THIS_DIR"
    return 1
  fi
}

install_cspell_config() {
  mkdir -p "$TARGET_DIR" || return 1
  ln -snfv "$THIS_DIR/$TARGET_FILE" "$TARGET_DIR/$TARGET_FILE" || return 1
  log "Linked $TARGET_FILE to $TARGET_DIR"
}

main() {
  check_requirements || exit 1
  install_cspell_config || exit 1
}

main
