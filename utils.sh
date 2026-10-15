#!/bin/bash

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error_handler() {
  log "Error occurred at line: $1"
  exit 1
}

run_setup() {
  local module=$1
  local module_dir="$THIS_DIR/src/$module"
  log "Setting up $module..."

  if [ ! -d "$module_dir" ]; then
    log "Error: $module directory not found"
    return 1
  fi

  if [ ! -f "$module_dir/setup.sh" ]; then
    log "Error: $module setup script not found"
    return 1
  fi

  cd "$module_dir" || return 1
  ./setup.sh
  cd "$THIS_DIR" || return 1
}
