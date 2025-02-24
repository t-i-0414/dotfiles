#!/bin/bash

cd "$(dirname "$0")" || exit 1

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if command -v brew >/dev/null 2>&1; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    echo "eval \"\$($(which /opt/homebrew/bin/brew) shellenv)\"" >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "eval \"\$($(which /usr/local/bin/brew) shellenv)\"" >>~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if [[ "$(uname -m)" == "arm64" ]]; then
  echo "Installing Rosetta 2..."
  sudo softwareupdate --install-rosetta --agree-to-license
fi

echo "Running 'brew doctor' ..."
brew doctor

echo "Running 'brew update' ..."
brew update

echo "Running 'brew upgrade' ..."
brew upgrade

if [ -f Brewfile ]; then
  echo "Running 'brew bundle' ..."
  brew bundle
else
  echo "Skipping 'brew bundle' (No Brewfile found)."
fi

echo "Running 'brew autoremove' ..."
brew autoremove

echo "Running 'brew cleanup' ..."
brew cleanup
