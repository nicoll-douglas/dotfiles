#!/bin/bash

set -e

# make sure `stow` is installed
if ! command -v stow > /dev/null 2>&1; then
  echo "stow is not installed. run the install.sh script first before running this one."
fi

here="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
cd $here

echo "Stowing all directories in $here to $HOME"

# change directory to here

# run stow for all directories that dont start with _ and target home directory
for item in $here/*; do
  basename=$(basename $item)
  if [[ -d "$item" && ! $basename =~ ^_ ]]; then
    stow -v --target=$HOME $(basename $item)
  fi
done

# apply gsettings config
source ./_scripts/gsettings.sh