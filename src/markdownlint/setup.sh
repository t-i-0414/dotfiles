#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_CONFIG_DIR="$THIS_DIR/../../node_modules/dev-config"
BASE_SOURCE="src/markdownlint-cli2.jsonc"
# 正本の新しい名前に合わせてリンク名を変えないのは、エディタの設定が base.markdownlint-cli2.jsonc を読んでいるため
BASE_FILE="base.markdownlint-cli2.jsonc"
TARGET_DIR="$HOME/.config/markdownlint"
LEGACY_FILE="$HOME/.markdownlint.json"

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../../utils.sh"

check_requirements() {
  if [ ! -f "$DEV_CONFIG_DIR/$BASE_SOURCE" ]; then
    log "エラー: dev-config の $BASE_SOURCE がありません。先に repo のルートで 'mise run setup' を実行してください"
    return 1
  fi
}

remove_legacy_config() {
  if [ -L "$LEGACY_FILE" ]; then
    rm "$LEGACY_FILE" || return 1
    log "$LEGACY_FILE を消しました"
  fi
}

install_markdownlint_config() {
  mkdir -p "$TARGET_DIR" || return 1
  ln -snfv "$(cd "$DEV_CONFIG_DIR" && pwd)/$BASE_SOURCE" "$TARGET_DIR/$BASE_FILE" || return 1
  log "$BASE_FILE を $TARGET_DIR にリンクしました"
}

main() {
  check_requirements || exit 1
  remove_legacy_config || exit 1
  install_markdownlint_config || exit 1
}

main
