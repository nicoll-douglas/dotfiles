#!/bin/bash

if ! command -v stow > /dev/null 2>&1; then
  echo "stow is not installed. run the install.sh script first before running this one."
fi

set -e

here="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
cd $here/..
dotfiles=$(pwd)

echo "Stowing all directories in $dotfiles to $HOME"

# run stow for all directories that dont start with _ and target home directory
for item in $dotfiles/*; do
  basename=$(basename $item)
  if [[ -d "$item" && ! $basename =~ ^_ ]]; then
    stow -v --target=$HOME $(basename $item)
  fi
done