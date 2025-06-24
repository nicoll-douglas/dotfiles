#!/bin/bash
# stows the packages in this repo and applies the gsettings configs

# run stow script
source ./_scripts/stow.sh

# apply gsettings config
source ./_scripts/gsettings.sh