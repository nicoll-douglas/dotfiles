#!/bin/bash
# installs necessary packages to run setup script and user binaries

here="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
cd $here

packages_list=./_conf/packages
packages=$(tr '\n' ' ' < $packages_list)

echo "Updating system package list"
sudo apt update

echo "Installing packages declared in _conf/packages:"
echo $packages
sudo apt install $packages
