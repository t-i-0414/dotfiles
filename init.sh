#!/bin/bash
cd "$(dirname "$0")"

THIS_DIR=$(cd $(dirname $0); pwd)

for dotfile in .alias.zsh .gitconfig .gitignore .zprofile .zshrc; do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done

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
  ./setup.sh
cd $THIS_DIR

# mac
echo "setup mac..."
cd $THIS_DIR/mac
  ./setup.sh
cd $THIS_DIR

# powerline font
echo "setup powerline font..."
cd $HOME
if (git clone https://github.com/powerline/fonts >/dev/null 2>&1); then
  git clone https://github.com/powerline/fonts
  cd fonts
  ./install.sh
fi


# oh-my-zsh
echo "setup oh-my-zsh..."
cd $THIS_DIR
if (curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh >/dev/null 2>&1); then
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi
