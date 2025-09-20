#!/bin/bash
# stows the packages in this repo and applies the gsettings configs

here="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
cd $here

# run stow script
source ./stow.sh

# apply gsettings config
source ./gsettings.sh

# refresh bash
source ~/.bashrc
echo "Freshly sourced .bashrc"