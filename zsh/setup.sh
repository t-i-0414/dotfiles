#!/bin/bash

for dotfile in .zprofile .zshrc; do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
