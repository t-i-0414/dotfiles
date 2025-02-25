#!/bin/bash

touch "$HOME/.hushlogin"

for dotfile in .zprofile .zshrc; do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
