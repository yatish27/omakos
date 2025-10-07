#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

step "Setting up mise (modern development environment manager)..."

# Check if mise is installed
if ! command -v mise &>/dev/null; then
  print_error "mise is not installed. Please ensure it's installed via Homebrew first."
  exit 1
fi

print_success_muted "mise detected"

# Copy mise configuration
if [ -f "./configs/mise.toml" ]; then
  step "Setting up mise configuration..."
  if [ ! -f "$HOME/.mise.toml" ]; then
    cp "./configs/mise.toml" "$HOME/.mise.toml"
    print_success "mise configuration installed"
  elif files_are_identical "$HOME/.mise.toml" "./configs/mise.toml"; then
    print_success_muted "mise configuration already up to date"
  elif confirm_override "$HOME/.mise.toml" "./configs/mise.toml" "mise configuration"; then
    cp "./configs/mise.toml" "$HOME/.mise.toml"
    print_success "mise configuration installed"
  else
    print_muted "Skipping mise configuration"
  fi
else
  print_warning "mise configuration file not found"
fi

# Check if mise configuration exists in home directory
if [ -f "$HOME/.mise.toml" ]; then
  step "mise configuration found in home directory"

  # Install configured tools
  step "Installing development tools..."
  mise install

  # Print versions of installed tools
  step "Installed versions:"
  echo "----------------------------------------"
  mise exec rust -- rustc --version
  mise exec ruby -- ruby --version
  mise exec go -- go version
  mise exec node -- node --version
  mise exec python -- python --version
  echo "----------------------------------------"

  print_success "All development tools installed successfully!"
else
  print_warning "mise configuration file not found in home directory"
fi