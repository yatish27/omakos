#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

config_file="./configs/iterm2/com.googlecode.iterm2.plist"
target_file="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

mkdir -p "$HOME/Library/Preferences"

if [ -f "$config_file" ]; then
  step "Setting up iTerm2 configuration..."
  if [ ! -f "$target_file" ]; then
    cp "$config_file" "$target_file"
    print_success "iTerm2 configuration installed"
  elif files_are_identical "$target_file" "$config_file"; then
    print_success_muted "iTerm2 configuration already up to date"
  elif confirm_override "$target_file" "$config_file" "iTerm2 configuration"; then
    cp "$config_file" "$target_file"
    print_success "iTerm2 configuration installed"
  else
    print_muted "Skipping iTerm2 configuration"
  fi
else
  print_warning "iTerm2 configuration file not found"
fi
