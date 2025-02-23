#!/bin/bash

source ./scripts/utils.sh

# Check if Cursor is installed via Homebrew
if ! brew list --cask | grep -q "^cursor$"; then
  print_error "Cursor is not installed. Please ensure it was installed via Homebrew"
  exit 1
fi

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

# Install extensions
step "Installing Cursor extensions..."
if [ -f "configs/cursor/extensions.txt" ]; then
  CURSOR_PATH="/Applications/Cursor.app/Contents/MacOS/Cursor"
  if [ ! -f "$CURSOR_PATH" ]; then
    print_error "Cursor executable not found at: $CURSOR_PATH"
    exit 1
  fi

  while IFS= read -r extension || [ -n "$extension" ]; do
    if [ ! -z "$extension" ]; then
      print_muted "Installing extension: $extension"
      "$CURSOR_PATH" --install-extension "$extension" >/dev/null 2>&1 || print_warning "Failed to install extension: $extension"
    fi
  done <"configs/cursor/extensions.txt"
  print_success_muted "Extensions installed successfully!"
else
  print_warning "Extensions file not found at configs/cursor/extensions.txt"
fi

print_success "Cursor setup completed!"
