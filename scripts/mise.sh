#!/bin/bash

# Source utility functions
source ./scripts/utils.sh

step "Setting up mise (modern development environment manager)..."

# Check if mise is installed
if ! command -v mise &>/dev/null; then
  print_error "mise is not installed. Please ensure it's installed via Homebrew first."
  exit 1
fi

print_success_muted "mise detected"

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
  mise exec java -- java -version
  echo "----------------------------------------"

  print_success "All development tools installed successfully!"
else
  print_warning "mise configuration file not found in home directory"
fi
