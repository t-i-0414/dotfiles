#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

if !(which /opt/homebrew/bin/brew >/dev/null 2>&1); then
  echo "installing Homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if !(which xcode-select >/dev/null 2>&1); then
  xcode-select --install
fi
