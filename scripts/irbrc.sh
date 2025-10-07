#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Copy irbrc configuration
if [ -f "./configs/irbrc" ]; then
  step "Setting up IRB configuration..."
  if [ ! -f "$HOME/.irbrc" ]; then
    cp "./configs/irbrc" "$HOME/.irbrc"
    print_success "IRB configuration installed"
  elif files_are_identical "$HOME/.irbrc" "./configs/irbrc"; then
    print_success_muted "IRB configuration already up to date"
  elif confirm_override "$HOME/.irbrc" "./configs/irbrc" "IRB configuration"; then
    cp "./configs/irbrc" "$HOME/.irbrc"
    print_success "IRB configuration installed"
  else
    print_muted "Skipping IRB configuration"
  fi
else
  print_warning "IRB configuration file not found"
fi
