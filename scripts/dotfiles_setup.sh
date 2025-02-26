#!/bin/bash

# Source utility functions
source ./scripts/utils.sh

# Create the .config directory if it doesn't exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/ghostty"

# Function to check if file exists and confirm override
confirm_override() {
  local file="$1"
  if [ -f "$file" ]; then
    if ask "$(basename "$file") already exists. Do you want to override it?" N; then
      return 0
    else
      return 1
    fi
  fi
  return 0
}

# Copy ghostty configuration
if [ -f "./configs/ghostty.conf" ]; then
  step "Setting up Ghostty configuration..."
  if confirm_override "$HOME/.config/ghostty/config"; then
    cp "./configs/ghostty.conf" "$HOME/.config/ghostty/config"
    print_success "Ghostty configuration installed"
  else
    print_muted "Skipping Ghostty configuration"
  fi
else
  print_warning "Ghostty configuration file not found"
fi

# Copy rubocop configuration
if [ -f "./configs/rubocop.yml" ]; then
  step "Setting up Rubocop configuration..."
  if confirm_override "$HOME/.config/rubocop.yml"; then
    cp "./configs/rubocop.yml" "$HOME/.config/rubocop.yml"
    print_success "Rubocop configuration installed"
  else
    print_muted "Skipping Rubocop configuration"
  fi
else
  print_warning "Rubocop configuration file not found"
fi

# Copy gemrc configuration
if [ -f "./configs/gemrc" ]; then
  step "Setting up Gem configuration..."
  if confirm_override "$HOME/.gemrc"; then
    cp "./configs/gemrc" "$HOME/.gemrc"
    print_success "Gem configuration installed"
  else
    print_muted "Skipping Gem configuration"
  fi
else
  print_warning "Gem configuration file not found"
fi

# Copy zshrc configuration
if [ -f "./configs/zshrc" ]; then
  step "Setting up Zsh configuration..."
  if confirm_override "$HOME/.zshrc"; then
    cp "./configs/zshrc" "$HOME/.zshrc"
    print_success "Zsh configuration installed"
  else
    print_muted "Skipping Zsh configuration"
  fi
else
  print_warning "Zsh configuration file not found"
fi

# Copy mise configuration
if [ -f "./configs/mise.toml" ]; then
  step "Setting up mise configuration..."
  if confirm_override "$HOME/.mise.toml"; then
    cp "./configs/mise.toml" "$HOME/.mise.toml"
    print_success "mise configuration installed"
  else
    print_muted "Skipping mise configuration"
  fi
else
  print_warning "mise configuration file not found"
fi
