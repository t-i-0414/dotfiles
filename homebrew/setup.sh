#!/bin/bash
cd "$(dirname "$0")"

if !(type "brew" >/dev/null 2>&1); then
  echo "installing Homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

sudo softwareupdate --install-rosetta --agree-to-license

echo "run brew doctor ..."
brew doctor

echo "run brew update ..."
brew update

echo "run brew upgrade ..."
brew upgrade

echo "run brew bundle ..."
brew bundle

echo "run brew cleanup ..."
brew cleanup
