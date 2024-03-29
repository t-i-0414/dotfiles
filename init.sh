#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

THIS_DIR=$(cd $(dirname $0); pwd)

for dotfile in .gitconfig .gitignore .zprofile .zshrc .hushlogin; do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done

ln -fs "$(pwd)/starship.toml" "$HOME/.config/starship.toml"

# xcode
echo "homebrew & xcode are installing..."
cd $THIS_DIR/xcode
  ./setup.sh
cd $THIS_DIR

# homebrew
echo "CUI & GUI Softwares are installing..."
cd $THIS_DIR/homebrew
  ./setup.sh
cd $THIS_DIR

# asdf
echo "setup asdf..."
cd $THIS_DIR/asdf
  ./setup.sh .tool-versions
cd $THIS_DIR

# mac
echo "setup mac..."
cd $THIS_DIR/mac
  ./setup.sh
cd $THIS_DIR

# tmux
ln -snfv "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
