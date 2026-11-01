#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# cmux loads this after shared Ghostty config, so these appearance settings win.
cmux_config_dir="$HOME/Library/Application Support/com.cmuxterm.app"
mkdir -p "$cmux_config_dir"

# Install the existing terminal font, spacing, cursor, and color palette.
if [ -f "./configs/cmux.conf" ]; then
  step "Setting up cmux configuration..."
  if [ ! -f "$cmux_config_dir/config.ghostty" ]; then
    cp "./configs/cmux.conf" "$cmux_config_dir/config.ghostty"
    print_success "cmux configuration installed"
  elif files_are_identical "$cmux_config_dir/config.ghostty" "./configs/cmux.conf"; then
    print_success_muted "cmux configuration already up to date"
  elif confirm_override "$cmux_config_dir/config.ghostty" "./configs/cmux.conf" "cmux configuration"; then
    cp "./configs/cmux.conf" "$cmux_config_dir/config.ghostty"
    print_success "cmux configuration installed"
  else
    print_muted "Skipping cmux configuration"
  fi
else
  print_warning "cmux configuration file not found"
fi
