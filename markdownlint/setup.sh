#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_CONFIG_DIR="$THIS_DIR/../node_modules/dev-config"
BASE_FILE="base.markdownlint-cli2.jsonc"
TARGET_DIR="$HOME/.config/markdownlint"
LEGACY_FILE="$HOME/.markdownlint.json"

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../utils.sh"

check_requirements() {
  if [ ! -f "$DEV_CONFIG_DIR/$BASE_FILE" ]; then
    log "Error: $BASE_FILE not found. Run 'mise run setup' in the repository root first"
    return 1
  fi
}

remove_legacy_config() {
  if [ -L "$LEGACY_FILE" ]; then
    rm "$LEGACY_FILE" || return 1
    log "Removed $LEGACY_FILE"
  fi
}

install_markdownlint_config() {
  mkdir -p "$TARGET_DIR" || return 1
  ln -snfv "$(cd "$DEV_CONFIG_DIR" && pwd)/$BASE_FILE" "$TARGET_DIR/$BASE_FILE" || return 1
  log "Linked $BASE_FILE to $TARGET_DIR"
}

main() {
  check_requirements || exit 1
  remove_legacy_config || exit 1
  install_markdownlint_config || exit 1
}

main
