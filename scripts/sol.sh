#!/bin/bash

set -e

source ./scripts/utils.sh

step "Configuring Sol as the Command-Space launcher..."

# Do not take away Spotlight's shortcut unless its replacement is installed.
if ! open -Ra Sol; then
  print_error "Install Sol first with: brew install --cask sol"
  exit 1
fi

# Sol persists its JSON settings while running, so quit before merging them.
if pgrep -x Sol >/dev/null; then
  osascript -e 'tell application "Sol" to quit'
fi

sol_config_dir="$HOME/.config/sol"
sol_config_file="$sol_config_dir/config.json"
mkdir -p "$sol_config_dir"
sol_config_temp=$(mktemp "$sol_config_dir/.config.XXXXXX")

if [ -f "$sol_config_file" ]; then
  # Preserve custom items, shortcuts, search folders, and all unrelated settings.
  if ! jq -e -s --slurpfile settings ./configs/sol/config.json \
    'if length == 1 and (.[0] | type == "object") then .[0] * $settings[0] else error("Sol config must be one object") end' \
    "$sol_config_file" > "$sol_config_temp"; then
    rm -f "$sol_config_temp"
    print_error "Could not read Sol config. Existing settings and Spotlight shortcuts were left unchanged."
    exit 1
  fi
  if ! files_are_identical "$sol_config_file" "$sol_config_temp"; then
    sol_config_backup=$(mktemp "$sol_config_dir/config.json.backup.XXXXXX")
    cp "$sol_config_file" "$sol_config_backup"
    print_muted "Previous Sol configuration saved to $sol_config_backup"
  fi
else
  cp ./configs/sol/config.json "$sol_config_temp"
fi
mv "$sol_config_temp" "$sol_config_file"

# Merge just the two Spotlight shortcuts; keep all other system shortcuts.
# Leave Spotlight indexing available for file search.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add \
  64 '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>' \
  65 '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>'

# Make the shortcut change available now when the macOS helper is present.
if ! PATH="$PATH:/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources" \
  activateSettings -u; then
  print_warning "Log out and back in to apply the Spotlight shortcut changes."
fi

open -a Sol
print_success "Sol configured for Command-Space and launch at login"
print_muted "Complete Sol's first-launch permissions if prompted. Quit other launchers if they also use Command-Space."
