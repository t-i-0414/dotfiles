#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

if command -v source >/dev/null 2>&1; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../utils.sh"

check_requirements() {
  if ! command -v xcode-select &>/dev/null; then
    log "Error: xcode-select command not found"
    return 1
  fi
}

install_xcode_command_line_tools() {
  if ! xcode-select -p &>/dev/null; then
    log "Installing Xcode Command Line Tools..."
    xcode-select --install
    log "Please complete the installation in the system dialog"
    log "After installation completes, run this script again"
    exit 0
  else
    log "Xcode Command Line Tools are already installed"
  fi
}

main() {
  check_requirements || exit 1
  install_xcode_command_line_tools || exit 1
}

main
