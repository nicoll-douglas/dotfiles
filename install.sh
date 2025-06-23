# require root
if [ "$EUID" -ne 0 ]; then
  echo "run as root."
  exit 1
fi

set -e

# make sure `stow` is installed
if command -v stow > /dev/null 2>&1; then
  echo "stow is installed."
else
  echo "installing stow..."
  sudo apt update
  sudo apt install stow
fi

# change directory to here
cd "$(dirname "${BASH_SOURCE[0]}")"

# run stow for all directories and target home directory
for item in $PWD; do
  if [ -d "$item" ]; then
    stow --target=${HOME} $(basename $item)
  fi
done

# apply gsettings config
if command -v gsettings >/dev/null 2>&1; then
  echo "Most likely using a desktop so applying gsettings config..."
  source ./gsettings.sh

  echo "Installing dmenu"
  sudo apt install dmenu
else
  echo "Most likely not using a desktop so not applying gsettings config"
fi
