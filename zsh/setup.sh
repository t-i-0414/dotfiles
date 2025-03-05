#!/bin/bash

for dotfile in .hushlogin .zprofile .zshrc; do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
