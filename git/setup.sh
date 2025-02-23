#!/bin/bash

for dotfile in .gitconfig .gitignore; do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
