#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

ln -snfv "$(pwd)/.tool-versions" "$HOME/.tool-versions"
ln -snfv "$(pwd)/.asdfrc" "$HOME/.asdfrc"

for plugin in terraform awscli python ruby; do
  if (asdf plugin add "$plugin" >/dev/null 2>&1); then
    asdf plugin add "$plugin"
  fi
done

asdf install
