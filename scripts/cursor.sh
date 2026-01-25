#!/bin/bash

set -e

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

print_success "Cursor setup completed!"
