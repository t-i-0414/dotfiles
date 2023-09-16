#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"


ln -snfv "$(pwd)/.tool-versions" "$HOME/.tool-versions"
ln -snfv "$(pwd)/.asdfrc" "$HOME/.asdfrc"

if [ -f $1 ]; then
  while read line
    do
      declare plugin=$(echo $line | cut -d ' ' -f 1)
      set +e
      asdf plugin add "$plugin"
      set -e
  done < $1
fi

sudo asdf install
