#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Create the .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Copy rubocop configuration
if [ -f "./configs/rubocop.yml" ]; then
  step "Setting up Rubocop configuration..."
  if [ ! -f "$HOME/.rubocop.yml" ]; then
    cp "./configs/rubocop.yml" "$HOME/.rubocop.yml"
    print_success "Rubocop configuration installed"
  elif files_are_identical "$HOME/.rubocop.yml" "./configs/rubocop.yml"; then
    print_success_muted "Rubocop configuration already up to date"
  elif confirm_override "$HOME/.rubocop.yml" "./configs/rubocop.yml" "Rubocop configuration"; then
    cp "./configs/rubocop.yml" "$HOME/.rubocop.yml"
    print_success "Rubocop configuration installed"
  else
    print_muted "Skipping Rubocop configuration"
  fi
else
  print_warning "Rubocop configuration file not found"
fi
