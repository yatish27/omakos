#!/bin/bash

set -e

source ./scripts/utils.sh

# Check if Cursor is installed via Homebrew
if ! brew list --cask | grep -q "^cursor$"; then
  print_error "Cursor is not installed. Please ensure it was installed via Homebrew"
  exit 1
fi

# Homebrew installs the app before its CLI has been added to the shell PATH.
CURSOR_CLI=$(command -v cursor || true)
if [ -z "$CURSOR_CLI" ]; then
  for app_dir in /Applications "$HOME/Applications"; do
    if [ -x "$app_dir/Cursor.app/Contents/Resources/app/bin/cursor" ]; then
      CURSOR_CLI="$app_dir/Cursor.app/Contents/Resources/app/bin/cursor"
      break
    fi
  done
fi
if [ -z "$CURSOR_CLI" ]; then
  print_error "Could not find the Cursor CLI. Add Cursor's shell command to PATH and rerun setup."
  exit 1
fi

step "Installing Cursor extensions..."
installed_extensions=$("$CURSOR_CLI" --list-extensions)
while IFS= read -r extension || [ -n "$extension" ]; do
  extension=${extension%$'\r'}
  case "$extension" in "" | \#*) continue ;; esac
  if ! printf '%s\n' "$installed_extensions" | grep -Fxiq -- "$extension"; then
    "$CURSOR_CLI" --install-extension "$extension"
  fi
done <configs/cursor/extensions.txt

# Create Cursor config directories if they don't exist
CURSOR_CONFIG_DIR="$HOME/Library/Application Support/Cursor"
CURSOR_USER_DIR="$CURSOR_CONFIG_DIR/User"

step "Setting up Cursor configuration directories..."
mkdir -p "$CURSOR_USER_DIR"

# Backup existing settings if they exist
if [ -f "$CURSOR_USER_DIR/settings.json" ]; then
  step "Backing up existing Cursor settings..."
  cp "$CURSOR_USER_DIR/settings.json" "$CURSOR_USER_DIR/settings.json.backup"
fi

# Copy new settings
step "Installing Cursor settings..."
cp configs/cursor/settings.json "$CURSOR_USER_DIR/settings.json"

print_success "Cursor setup completed!"
