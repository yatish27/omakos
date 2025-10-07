#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Create the Zed config directory if it doesn't exist
mkdir -p "$HOME/.config/zed"

# Copy Zed settings
if [ -f "./configs/zed/settings.json" ]; then
  step "Setting up Zed configuration..."
  if [ ! -f "$HOME/.config/zed/settings.json" ]; then
    cp "./configs/zed/settings.json" "$HOME/.config/zed/settings.json"
    print_success "Zed configuration installed"
  elif files_are_identical "$HOME/.config/zed/settings.json" "./configs/zed/settings.json"; then
    print_success_muted "Zed configuration already up to date"
  elif confirm_override "$HOME/.config/zed/settings.json" "./configs/zed/settings.json" "Zed configuration"; then
    cp "./configs/zed/settings.json" "$HOME/.config/zed/settings.json"
    print_success "Zed configuration installed"
  else
    print_muted "Skipping Zed configuration"
  fi
else
  print_warning "Zed configuration file not found"
fi
