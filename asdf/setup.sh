#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

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
  if ! command -v asdf >/dev/null 2>&1; then
    log "Error: asdf is not installed"
    return 1
  fi

  for file in .tool-versions .asdfrc; do
    if [ ! -f "$THIS_DIR/$file" ]; then
      log "Error: $file not found"
      return 1
    fi
  done
}

create_symlinks() {
  ln -sf "$THIS_DIR/.tool-versions" "$HOME/.tool-versions"
  ln -sf "$THIS_DIR/.asdfrc" "$HOME/.asdfrc"
}

setup_plugins() {
  awk '!/^#/ && NF>1 { print $1 }' "$THIS_DIR/.tool-versions" | while read -r plugin; do
    if asdf plugin list | awk '{print $1}' | grep -Fxq "$plugin"; then
      continue
    fi

    asdf plugin add "$plugin" || {
      log "Error: Failed to add $plugin plugin"
      return 1
    }
  done
}

install_all() {
  awk '!/^#/ && NF>1 { print $1, $2 }' "$THIS_DIR/.tool-versions" | while read -r plugin version; do
    asdf install "$plugin" "$version" || {
      log "Error: Failed to install $plugin v$version"
      return 1
    }
  done
}

main() {
  check_requirements || exit 1
  create_symlinks || exit 1
  setup_plugins || exit 1
  install_all || exit 1
}

main
