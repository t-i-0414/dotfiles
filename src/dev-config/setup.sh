#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_CONFIG_SRC="$THIS_DIR/../../node_modules/dev-config/src"
TARGET_LINK="$HOME/.config/dev-config"
LEGACY_LINKS=(
  "$HOME/.markdownlint.json"
  "$HOME/.config/markdownlint/base.markdownlint-cli2.jsonc"
  "$HOME/.config/cspell/base.cspell.json"
)

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../../utils.sh"

check_requirements() {
  if [ ! -d "$DEV_CONFIG_SRC" ]; then
    log "エラー: dev-config の src がありません。先に repo のルートで 'mise run setup' を実行してください"
    return 1
  fi
}

remove_legacy_links() {
  for link in "${LEGACY_LINKS[@]}"; do
    if [ -L "$link" ]; then
      rm "$link" || return 1
      log "$link を消しました"
    fi
  done
  rmdir "$HOME/.config/markdownlint" 2>/dev/null || true
}

install_dev_config_link() {
  mkdir -p "$(dirname "$TARGET_LINK")" || return 1
  ln -snfv "$(cd "$DEV_CONFIG_SRC" && pwd)" "$TARGET_LINK" || return 1
  log "dev-config の正本を $TARGET_LINK にリンクしました"
}

main() {
  check_requirements || exit 1
  remove_legacy_links || exit 1
  install_dev_config_link || exit 1
}

main
