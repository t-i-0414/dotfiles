#!/bin/bash

cd "$(dirname "$0")" || exit 1

ln -snfv "$(pwd)/.tool-versions" "$HOME/.tool-versions"
ln -snfv "$(pwd)/.asdfrc" "$HOME/.asdfrc"

if [ -f "$1" ]; then
  while read -r line; do
    plugin=$(echo "$line" | awk '{print $1}')

    asdf plugin add "$plugin" || true
  done <"$1"
fi

asdf install
