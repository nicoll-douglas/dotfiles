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
  sudo apt update && sudo apt install stow
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
  source ./gsettings.sh
else
  echo "gsettings is not installed, not applying configurations"
fi
