#!/bin/bash

cd "$(dirname "$0")" || exit 1

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
else
  echo "Xcode Command Line Tools are already installed."
fi
