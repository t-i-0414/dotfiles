#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_FILE=".tmux.conf"

# shellcheck source=/dev/null
source "${THIS_DIR}/../utils.sh"

check_requirements() {
  if [ ! -f "$THIS_DIR/$TARGET_FILE" ]; then
    log "Error: $TARGET_FILE not found in $THIS_DIR"
    return 1
  fi
}

install_tmux_config() {
  ln -snfv "$THIS_DIR/$TARGET_FILE" "$HOME/$TARGET_FILE"
  log "Linked $TARGET_FILE to $HOME"
}

main() {
  check_requirements || exit 1
  install_tmux_config || exit 1
}

main
