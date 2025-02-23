#!/bin/bash

for dotfile in .zprofile .zshrc scripts; do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
