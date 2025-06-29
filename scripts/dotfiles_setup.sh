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

# Copy rubocop configuration
if [ -f "./configs/rubocop.yml" ]; then
  step "Setting up Rubocop configuration..."
  if [ ! -f "$HOME/.config/rubocop.yml" ]; then
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