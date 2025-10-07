#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Copy gemrc configuration
if [ -f "./configs/gemrc" ]; then
  step "Setting up Gem configuration..."
  if [ ! -f "$HOME/.gemrc" ]; then
    cp "./configs/gemrc" "$HOME/.gemrc"
    print_success "Gem configuration installed"
  elif files_are_identical "$HOME/.gemrc" "./configs/gemrc"; then
    print_success_muted "Gem configuration already up to date"
  elif confirm_override "$HOME/.gemrc" "./configs/gemrc" "Gem configuration"; then
    cp "./configs/gemrc" "$HOME/.gemrc"
    print_success "Gem configuration installed"
  else
    print_muted "Skipping Gem configuration"
  fi
else
  print_warning "Gem configuration file not found"
fi
