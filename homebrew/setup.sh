#!/bin/bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

# shellcheck source=/dev/null
source "${THIS_DIR}/../utils.sh"

setup_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log "Homebrew is already installed"
  fi

  if command -v brew >/dev/null 2>&1; then
    local brew_path
    if [[ "$(uname -m)" == "arm64" ]]; then
      brew_path="/opt/homebrew/bin/brew"
      log "Setting up environment for Apple Silicon..."
    else
      brew_path="/usr/local/bin/brew"
      log "Setting up environment for Intel Mac..."
    fi

    local shell_env="eval \"\$(${brew_path} shellenv)\""
    touch ~/.zprofile

    if grep -q "eval.*brew shellenv" ~/.zprofile; then
      (
        tmp_file=$(mktemp)
        trap 'rm -f "$tmp_file"' EXIT

        awk '
          /eval.*brew shellenv/ { if (!seen) print; seen=1; next }
          { print }
        ' ~/.zprofile >"$tmp_file" && mv "$tmp_file" ~/.zprofile
      )
    else
      echo "$shell_env" >>~/.zprofile
    fi
    log "Updated Homebrew environment in ~/.zprofile"
    eval "$($brew_path shellenv)"
  fi
}

setup_rosetta() {
  if [[ "$(uname -m)" == "arm64" ]]; then
    log "Installing Rosetta 2..."
    if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto >/dev/null 2>&1; then
      sudo softwareupdate --install-rosetta --agree-to-license
    else
      log "Rosetta 2 is already installed"
    fi
  fi
}

validate_brewfile() {
  log "Validating Brewfile..."
  if [ ! -f "$THIS_DIR/Brewfile" ]; then
    log "Error: Brewfile not found"
    exit 1
  fi

  if ! brew bundle check --file="$THIS_DIR/Brewfile" --no-upgrade >/dev/null 2>&1; then
    log "Warning: Potential issues found in Brewfile"
  else
    log "Brewfile validation completed"
  fi
}

maintenance() {
  log "Running brew doctor..."
  brew doctor

  log "Checking for updates..."
  brew update

  log "Upgrading packages..."
  brew upgrade

  if [ -f "$THIS_DIR/Brewfile" ]; then
    log "Installing packages from Brewfile..."
    brew bundle --file="$THIS_DIR/Brewfile"
  else
    log "Warning: Brewfile not found"
  fi

  log "Removing unnecessary packages..."
  brew autoremove

  log "Cleaning up old versions and cache..."
  brew cleanup

  log "Checking for unmanaged packages..."
  local unmanaged_formulae
  unmanaged_formulae=$(brew bundle cleanup --file="$THIS_DIR/Brewfile" --force)
  if [ -n "$unmanaged_formulae" ]; then
    log "Warning: The following packages are not managed in Brewfile:"
    echo "$unmanaged_formulae"
  fi
}

main() {
  log "Starting Homebrew setup..."

  setup_homebrew
  setup_rosetta
  validate_brewfile
  maintenance

  log "Homebrew setup completed successfully"
}

main
