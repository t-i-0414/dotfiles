#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../utils.sh"

check_requirements() {
  if ! command -v mise >/dev/null 2>&1; then
    log "Error: mise is not installed"
    return 1
  fi

  if [ ! -f "$THIS_DIR/config.toml" ]; then
    log "Error: config.toml not found"
    return 1
  fi
}

create_symlinks() {
  mkdir -p "$HOME/.config/mise"
  ln -sf "$THIS_DIR/config.toml" "$HOME/.config/mise/config.toml"
}

install_all() {
  mise install || {
    log "Error: Failed to install tools via mise"
    return 1
  }
}

main() {
  check_requirements || exit 1
  create_symlinks || exit 1
  install_all || exit 1
}

main
