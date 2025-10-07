#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Create the .config directory if it doesn't exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/ghostty"

# Copy ghostty configuration
if [ -f "./configs/ghostty.conf" ]; then
  step "Setting up Ghostty configuration..."
  if [ ! -f "$HOME/.config/ghostty/config" ]; then
    cp "./configs/ghostty.conf" "$HOME/.config/ghostty/config"
    print_success "Ghostty configuration installed"
  elif files_are_identical "$HOME/.config/ghostty/config" "./configs/ghostty.conf"; then
    print_success_muted "Ghostty configuration already up to date"
  elif confirm_override "$HOME/.config/ghostty/config" "./configs/ghostty.conf" "Ghostty configuration"; then
    cp "./configs/ghostty.conf" "$HOME/.config/ghostty/config"
    print_success "Ghostty configuration installed"
  else
    print_muted "Skipping Ghostty configuration"
  fi
else
  print_warning "Ghostty configuration file not found"
fi
