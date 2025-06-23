#!/bin/bash

set -e

config_file="gsettings.conf"
current_schema=""

# change directory to here
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Applying gsettings configuration..."

# loop over config lines
while IFS= read -r line; do
  # skip comments and empty lines
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # Handle schema lines
  if [[ "$line" =~ ^\[(.*)\]$ ]]; then
    current_schema="${BASH_REMATCH[1]}"
    keys=$(gsettings list-keys "$current_schema")

    echo "Resetting all keys in $current_schema..."
    
    for key in $keys; do
      gsettings set "$current_schema" "$key" "[]" || true
    done

    continue
  fi

  # Handle key value pairs
  if [[ "$line" =~ ^([a-zA-Z0-9._-]+)=\"(.+)\"$ ]]; then
    key="${BASH_REMATCH[1]}"
    value="${BASH_REMATCH[2]}"
  else
    continue
  fi

  # Run the gsettings command
  if [[ -n "$current_schema" ]]; then
    gsettings set "$current_schema" "$key" "$value" || true
  fi

done < "$config_file"

config_file="keybinds.conf"
base_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
paths=()
index=0

echo "Applying custom keybindings to gsettings"

while IFS= read -r line || [[ -n "$line" ]]; do
  # Skip empty lines or comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # Parse name, command, shortcut
  IFS='|' read -r name command shortcut <<< "$line"
  name=$(echo "$name" | xargs)
  command=$(echo "$command" | xargs)
  shortcut=$(echo "$shortcut" | xargs)

  path="$base_path/custom$index/"
  paths+=("'$path'")

  # Set keybinding values
  gsettings set $schema:$path name "$name"
  gsettings set $schema:$path command "$command"
  gsettings set $schema:$path binding "$shortcut"

  ((index++))
done < "$config_file"

# Join paths
custom_list="["
custom_list+=$(IFS=,; echo "${paths[*]}")
custom_list+="]"

# Apply the full custom-keybindings list at once
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_list"

echo "Applied all custom keybindings."
