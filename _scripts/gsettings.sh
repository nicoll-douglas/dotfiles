#!/bin/bash
# parses and applies ../_conf/gsettings.conf and ../_conf/keybinds.conf with the gsettings command

set -e

# change directory to here
cd "$(dirname "${BASH_SOURCE[0]}")"

# STEP 1: Apply gsettings rules defined in ../_conf/gsettings.conf

config_file="../_conf/gsettings.conf"
config_basename=$(basename $config_file)
current_schema=""

echo "Applying rules in $config_basename to gsettings..."

# loop over config lines
while IFS= read -r line || [[ -n "$line" ]]; do
  # skip comments and empty lines
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # Handle schema lines
  if [[ "$line" =~ ^\[(.*)\]$ ]]; then
    current_schema="${BASH_REMATCH[1]}"
    keys=$(gsettings list-keys "$current_schema")

    echo "Resetting all keys in schema '$current_schema'..."
    
    for key in $keys; do
      if ! gsettings set "$current_schema" "$key" "[]"; then
        echo "Failed to reset key '$key' in schema '$current_schema'."
      fi
    done

    echo "Applying configured keys for '$current_schema' defined in $config_basename..."

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
    if ! gsettings set "$current_schema" "$key" "$value"; then
      echo "Failed to set value '$value' for key '$key' in schema '$current_schema'."
    fi
  fi

done < "$config_file"

echo "Finished applying rules in $config_basename to gsettings."

# STEP 2: Apply gsettings custom keybinds defined in ../_conf/keybinds.conf

config_file="../_conf/keybinds.conf"
config_basename=$(basename $config_file)
base_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
paths=()
index=0

echo "Applying keybinds in $config_basename to gsettings..."

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

  ((index+=1))
done < "$config_file"

# Join paths
custom_list="["
custom_list+=$(IFS=,; echo "${paths[*]}")
custom_list+="]"

# Apply the full custom-keybindings list at once
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_list"

echo "Finished applying keybinds in $config_basename to gsettings."