#!/bin/bash

BASE_DIR="$HOME/workspace"

for dir in "$BASE_DIR"/*/; do
  if [ -d "$dir" ]; then
    if [ -d "$dir/.git" ]; then
      echo "Processing: $dir"
      cd "$dir" || continue

      DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

      if [ -n "$DEFAULT_BRANCH" ]; then
        echo "Pulling latest changes from $DEFAULT_BRANCH..."
        git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"
      else
        echo "Could not determine default branch for $dir"
      fi

      cd "$BASE_DIR" || exit
    else
      echo "Skipping (not a git repository): $dir"
    fi
  fi
done

echo "All repositories updated."
