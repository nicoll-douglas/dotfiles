#!/bin/bash
# stows the packages in this repo and applies the gsettings configs

here="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

# run stow script
source $here/stow.sh

# apply gsettings config
source $here/gsettings.sh

# refresh bash
source ~/.bashrc
echo "Freshly sourced .bashrc"