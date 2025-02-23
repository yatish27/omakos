#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}${BOLD}Omakos${NC}"
echo -e "${BOLD}Turn your MacOS laptop into a fully functional development system${NC}\n"

# Check for required commands
command -v curl >/dev/null 2>&1 || {
  echo -e "${RED}Error: curl is required but not installed.${NC}" >&2
  exit 1
}
command -v unzip >/dev/null 2>&1 || {
  echo -e "${RED}Error: unzip is required but not installed.${NC}" >&2
  exit 1
}

# Set install directory
INSTALL_DIR="$HOME/omakos"
TEMP_ZIP="/tmp/omakos.zip"

# Remove existing zip if present
rm -f "$TEMP_ZIP"

# Check if directory already exists
if [ -d "$INSTALL_DIR" ]; then
  echo -e "${BLUE}Removing existing Omakos installation...${NC}"
  rm -rf "$INSTALL_DIR"
fi

echo -e "${BLUE}Downloading Omakos...${NC}"
curl -L "https://github.com/yatish27/omakos/archive/refs/heads/main.zip" -o "$TEMP_ZIP"

echo -e "${BLUE}Extracting files...${NC}"
unzip -q "$TEMP_ZIP" -d "/tmp"
mv "/tmp/omakos-main" "$INSTALL_DIR"
rm -f "$TEMP_ZIP"

cd "$INSTALL_DIR"

# Make setup script executable
chmod +x setup.sh

echo -e "\n${GREEN}✓ Download complete!${NC}"
echo -e "${BLUE}Starting setup...${NC}\n"

# Run setup script
./setup.sh
