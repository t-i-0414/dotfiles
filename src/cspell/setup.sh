#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_CONFIG_DIR="$THIS_DIR/../../node_modules/dev-config"
TARGET_FILE="cspell.json"
BASE_SOURCE="src/cspell.json"
# 正本と同じ cspell.json という名前でリンクしないのは、TARGET_FILE とぶつかり、エディタの設定も base.cspell.json を読んでいるため
BASE_FILE="base.cspell.json"
TARGET_DIR="$HOME/.config/cspell"

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../../utils.sh"

check_requirements() {
  if [ ! -f "$THIS_DIR/$TARGET_FILE" ]; then
    log "エラー: $THIS_DIR に $TARGET_FILE がありません"
    return 1
  fi

  if [ ! -f "$DEV_CONFIG_DIR/$BASE_SOURCE" ]; then
    log "エラー: dev-config の $BASE_SOURCE がありません。先に repo のルートで 'mise run setup' を実行してください"
    return 1
  fi
}

install_cspell_config() {
  mkdir -p "$TARGET_DIR" || return 1
  ln -snfv "$THIS_DIR/$TARGET_FILE" "$TARGET_DIR/$TARGET_FILE" || return 1
  ln -snfv "$(cd "$DEV_CONFIG_DIR" && pwd)/$BASE_SOURCE" "$TARGET_DIR/$BASE_FILE" || return 1
  log "$TARGET_FILE と $BASE_FILE を $TARGET_DIR にリンクしました"
}

main() {
  check_requirements || exit 1
  install_cspell_config || exit 1
}

main
