#!/bin/bash

# Exit on error
set -e

# Check for required commands
command -v curl >/dev/null 2>&1 || {
  echo "Error: curl is required but not installed." >&2
  exit 1
}
command -v unzip >/dev/null 2>&1 || {
  echo "Error: unzip is required but not installed." >&2
  exit 1
}

# Stage on the same filesystem so the final move is a rename.
INSTALL_DIR="$HOME/omakos"
WORK_DIR=$(mktemp -d "$HOME/.omakos-install.XXXXXX")
trap 'rm -rf "$WORK_DIR"' EXIT
TEMP_ZIP="$WORK_DIR/omakos.zip"

echo "Downloading Omakos..."
curl -fL "https://github.com/yatish27/omakos/archive/refs/heads/main.zip" -o "$TEMP_ZIP"

echo "Extracting files..."
unzip -q "$TEMP_ZIP" -d "$WORK_DIR"
if [ ! -f "$WORK_DIR/omakos-main/setup.sh" ] ||
   [ ! -f "$WORK_DIR/omakos-main/scripts/utils.sh" ] ||
   [ ! -f "$WORK_DIR/omakos-main/configs/Brewfile" ]; then
  echo "Error: the downloaded archive is missing required installation files." >&2
  exit 1
fi
chmod +x "$WORK_DIR/omakos-main/setup.sh"

# Preserve existing checkouts, including local changes and Git history.
BACKUP_DIR=""
if [ -e "$INSTALL_DIR" ] || [ -L "$INSTALL_DIR" ]; then
  BACKUP_DIR=$(mktemp -d "$HOME/omakos.backup.XXXXXX")
  mv "$INSTALL_DIR" "$BACKUP_DIR/omakos"
  echo "Existing Omakos installation saved to $BACKUP_DIR/omakos"
fi

if ! mv "$WORK_DIR/omakos-main" "$INSTALL_DIR"; then
  if [ -n "$BACKUP_DIR" ]; then
    mv "$BACKUP_DIR/omakos" "$INSTALL_DIR"
    rmdir "$BACKUP_DIR"
  fi
  exit 1
fi

cd "$INSTALL_DIR"

printf '\n✓ Download complete!\nStarting setup...\n\n'

# The bootstrap may be piped into bash; interactive installers need the terminal.
./setup.sh </dev/tty
