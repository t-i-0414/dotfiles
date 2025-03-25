#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"
TARGET_FILE="starship.toml"

# shellcheck source=/dev/null
if [ -n "$BASH_VERSION" ]; then
  SOURCE_CMD="source"
elif [ -n "$ZSH_VERSION" ]; then
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

  mkdir -p "$CONFIG_DIR"
}

install_starship_config() {
  ln -snfv "$THIS_DIR/$TARGET_FILE" "$CONFIG_DIR/$TARGET_FILE"
  log "Linked $TARGET_FILE to $CONFIG_DIR"
}

main() {
  check_requirements || exit 1
  install_starship_config || exit 1
}

main
