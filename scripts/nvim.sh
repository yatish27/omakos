#!/bin/bash

set -e

source ./scripts/utils.sh

# Check if Neovim is installed via Homebrew
if ! brew list | grep -q "^neovim$"; then
  print_error "Neovim is not installed. Please ensure it was installed via Homebrew"
  exit 1
fi

# Create Neovim config directory if it doesn't exist
NVIM_CONFIG_DIR="$HOME/.config/nvim"

step "Setting up Neovim configuration directory..."
mkdir -p "$NVIM_CONFIG_DIR"

# Backup existing config if it exists
if [ -d "$NVIM_CONFIG_DIR" ] && [ "$(ls -A $NVIM_CONFIG_DIR)" ]; then
  step "Backing up existing Neovim configuration..."
  mv "$NVIM_CONFIG_DIR" "$NVIM_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$NVIM_CONFIG_DIR"
fi

# Copy new configuration
step "Installing Neovim configuration..."
cp -r configs/nvim/* "$NVIM_CONFIG_DIR/"

# Install LazyVim if not already present
step "Setting up LazyVim..."
if [ ! -d "$NVIM_CONFIG_DIR/lazy" ]; then
  print_muted "LazyVim will be automatically installed on first run"
fi

print_success "Neovim setup completed!"
print_muted "Run 'nvim' to start Neovim and complete the LazyVim installation"