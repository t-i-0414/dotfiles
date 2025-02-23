#!/bin/bash
set -euo pipefail

THIS_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
echo "Script Directory: $THIS_DIR"

touch "$HOME/.hushlogin"

# xcode
echo "homebrew & xcode are installing..."
cd "$THIS_DIR/xcode"
./setup.sh
cd "$THIS_DIR"

# homebrew
echo "CUI & GUI Softwares are installing..."
cd "$THIS_DIR/homebrew"
./setup.sh
cd "$THIS_DIR"

# asdf
echo "setup asdf..."
cd "$THIS_DIR/asdf"
./setup.sh .tool-versions
cd "$THIS_DIR"

# mac
echo "setup mac..."
cd "$THIS_DIR/mac"
./setup.sh
cd "$THIS_DIR"

# tmux
ln -snfv "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"

echo "setup git ..."
cd "$THIS_DIR/git"
./setup.sh

echo "setup starship..."
cd "$THIS_DIR/starship"
./setup.sh

echo "setup zsh..."
cd "$THIS_DIR/zsh"
./setup.sh
