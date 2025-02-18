#!/bin/bash

# Check if cursor command is available
if ! command -v cursor &>/dev/null; then
  echo "Cursor command line tool is not installed. Please install it."
  echo "You can do this by opening Cursor, pressing Cmd+Shift+P, and running 'Shell Command: Install 'cursor' command in PATH'"
fi

# Directory for Cursor settings
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"

# Backup existing settings
if [ -f "$CURSOR_USER_DIR/settings.json" ]; then
  mv "$CURSOR_USER_DIR/settings.json" "$CURSOR_USER_DIR/settings.json.backup"
fi

# Copy settings
cp configs/cursor/settings.json "$CURSOR_USER_DIR/settings.json"

# Install extensions
while read extension; do
  cursor --install-extension "$extension"
done <configs/cursor/extensions.txt

echo "Cursor settings and extensions have been updated."
