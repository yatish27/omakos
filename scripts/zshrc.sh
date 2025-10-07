#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Copy zshrc configuration
if [ -f "./configs/zshrc" ]; then
  step "Setting up Zsh configuration..."
  if [ ! -f "$HOME/.zshrc" ]; then
    cp "./configs/zshrc" "$HOME/.zshrc"
    print_success "Zsh configuration installed"
  elif files_are_identical "$HOME/.zshrc" "./configs/zshrc"; then
    print_success_muted "Zsh configuration already up to date"
  elif confirm_override "$HOME/.zshrc" "./configs/zshrc" "Zsh configuration"; then
    cp "./configs/zshrc" "$HOME/.zshrc"
    print_success "Zsh configuration installed"
  else
    print_muted "Skipping Zsh configuration"
  fi
else
  print_warning "Zsh configuration file not found"
fi
