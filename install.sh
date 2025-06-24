#!/bin/bash
# installs apt and snap packages

set -e

here="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
cd $here

config_file="./_conf/packages.conf"
section=""

while IFS= read -r line || [[ -n "$line" ]]; do
  # skip empty lines and comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  
  # detect section headers
  if [[ "$line" =~ ^\[(.*)\]$ ]]; then
    section="${BASH_REMATCH[1]}"
    continue
  fi
  
  # install apt packages
  if [[ "$section" == "apt" ]]; then
    echo "Installing apt package: '$line'"
    sudo apt install -y $(echo "$line" | xargs)

  # install snap packages  
  elif [[ "$section" == "snap" ]]; then
    # parse snap package lines, format: (package=classic?)
    if [[ "$line" =~ ^([^=]+)=(true|false)$ ]]; then
      pkg="${BASH_REMATCH[1]}"
      flag="${BASH_REMATCH[2]}"
      
      # detect flag
      if [[ "$flag" == "true" ]]; then
        echo "Installing snap package (classic): '$pkg'"
        sudo snap install "$pkg" --classic
      else
        echo "Installing snap package: '$pkg'"
        sudo snap install "$pkg"
      fi
    else
      echo "Skipping invalid snap line: '$line'"
    fi

  else
    continue
  fi
  
done < "$config_file"

echo "Finished installing packages."