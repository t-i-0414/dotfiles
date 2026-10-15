#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES=(".hushlogin" ".zprofile" ".zshrc")

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../../utils.sh"

check_requirements() {
  local missing_files=()

  for file in "${DOTFILES[@]}"; do
    if [ ! -f "$THIS_DIR/$file" ]; then
      missing_files+=("$file")
    fi
  done

  if [ ${#missing_files[@]} -ne 0 ]; then
    log "エラー: $THIS_DIR に次のファイルがありません"
    printf '%s\n' "${missing_files[@]}"
    return 1
  fi
}

install_zsh_config() {
  for file in "${DOTFILES[@]}"; do
    ln -snfv "$THIS_DIR/$file" "$HOME/$file"
    log "$file を $HOME にリンクしました"
  done
}

main() {
  check_requirements || exit 1
  install_zsh_config || exit 1
}

main
