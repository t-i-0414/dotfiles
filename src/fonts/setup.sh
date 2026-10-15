#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
FONT_DIR="$HOME/Library/Fonts"

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../../utils.sh"

check_requirements() {
  if [ ! -d "$FONT_DIR" ]; then
    log "エラー: フォントのディレクトリ $FONT_DIR がありません"
    return 1
  fi

  if ! compgen -G "$THIS_DIR/*.ttf" >/dev/null; then
    log "エラー: $THIS_DIR に .ttf ファイルがありません"
    return 1
  fi
}

install_fonts() {
  log "フォントを $FONT_DIR に入れます"

  for file in "$THIS_DIR"/*.ttf; do
    cp -v "$file" "$FONT_DIR"
  done

  log "フォントを入れました"
}

main() {
  check_requirements || exit 1
  install_fonts || exit 1
}

main
