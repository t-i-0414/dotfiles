#!/bin/bash

FONT_DIR="$HOME/Library/Fonts"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TTF_FILES=("$SCRIPT_DIR/*.ttf")

if [[ ${#TTF_FILES[@]} -eq 0 ]]; then
  echo "No .ttf files found in $SCRIPT_DIR"
  exit 1
fi

echo "Installing fonts to $FONT_DIR..."
cp -v "${TTF_FILES[@]}" "$FONT_DIR"

echo "Installation complete."
