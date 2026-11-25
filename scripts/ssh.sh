#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Create .ssh directory if it doesn't exist
if [ ! -d "$HOME/.ssh" ]; then
  step "Creating .ssh directory..."
  mkdir -p "$HOME/.ssh"
  print_success ".ssh directory created!"
fi
chmod 700 "$HOME/.ssh"

# Copy SSH config file
step "Copying SSH config..."
if [ -f "$HOME/.ssh/config" ]; then
  print_success_muted "SSH config already exists. Skipping."
else
  cp ./configs/ssh/config "$HOME/.ssh/config"
  print_success "SSH config copied!"
fi
chmod 600 "$HOME/.ssh/config"
