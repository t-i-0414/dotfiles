#!/bin/bash
set -euo pipefail

THIS_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
echo "Script Directory: $THIS_DIR"

echo "setup mac..."
cd "$THIS_DIR/mac"
./setup.sh
cd "$THIS_DIR"

echo "fonts are installing..."
cd "$THIS_DIR/fonts"
./setup.sh
cd "$THIS_DIR"

echo "xcode-select is installing..."
cd "$THIS_DIR/xcode"
./setup.sh
cd "$THIS_DIR"

echo "homebrew is installing..."
cd "$THIS_DIR/homebrew"
./setup.sh
cd "$THIS_DIR"

echo "setup git ..."
cd "$THIS_DIR/git"
./setup.sh
cd "$THIS_DIR"

echo "setup tmux..."
cd "$THIS_DIR/tmux"
./setup.sh
cd "$THIS_DIR"

echo "setup starship..."
cd "$THIS_DIR/starship"
./setup.sh
cd "$THIS_DIR"

echo "setup asdf..."
cd "$THIS_DIR/asdf"
./setup.sh
cd "$THIS_DIR"

echo "setup zsh..."
cd "$THIS_DIR/zsh"
./setup.sh
cd "$THIS_DIR"
