#!/bin/bash

set -e

source ./scripts/utils.sh

# Check if git is installed
if ! command -v git &>/dev/null; then
  print_error "Git is not installed. Please install Git first."
  exit 1
fi

print_muted "Setting up Git configuration..."

# Check if gitconfig template exists
if [ ! -f "configs/git/gitconfig" ]; then
  print_error "No gitconfig found in configs/git/gitconfig. Please create one first."
  exit 1
fi

# Flag to track if gitconfig was set up
gitconfig_setup=false

# Setup gitconfig if it doesn't exist or user agrees to override
if [ ! -f "$HOME/.gitconfig" ]; then
  print_muted "Copying gitconfig from configs/git/gitconfig..."
  cp configs/git/gitconfig ~/.gitconfig
  print_success_muted "Copied gitconfig file"
  gitconfig_setup=true
elif files_are_identical "$HOME/.gitconfig" "configs/git/gitconfig"; then
  print_success_muted "Git configuration already up to date"
  gitconfig_setup=true
elif confirm_override "$HOME/.gitconfig" "configs/git/gitconfig" ".gitconfig file"; then
  print_muted "Copying gitconfig from configs/git/gitconfig..."
  cp configs/git/gitconfig ~/.gitconfig
  print_success_muted "Copied gitconfig file"
  gitconfig_setup=true
else
  print_success_muted "Git configuration skipped."
fi

# Prompt for Git user information only if gitconfig is set up
if [ "$gitconfig_setup" = true ]; then
  print_muted "Setting up Git user information..."

  read -p "Enter your Git display name: " git_name
  git config --global user.name "$git_name"
  print_success_muted "Git name set to: $git_name"

  read -p "Enter your Git email: " git_email
  git config --global user.email "$git_email"
  print_success_muted "Git email set to: $git_email"

  print_success "Git setup completed!"
else

  print_success_muted "Git setup skipped."
fi

print_muted "Setting up Git Ignore..."

# Check if gitignore_global template exists
if [ ! -f "configs/git/gitignore_global" ]; then
  print_error "No gitignore found in configs/git/gitignore_global. Please create one first."
  exit 1
fi

# Setup gitignore_global if it doesn't exist or user agrees to override
if [ ! -f "$HOME/.gitignore_global" ] || ask "A .gitignore_global file already exists. Would you like to override it?" Y; then
  print_muted "Copying gitignore_global from configs/git/gitignore_global..."
  cp configs/git/gitignore_global ~/.gitignore_global
  print_success_muted "Copied gitignore_global file"

  # Set global gitignore
  git config --global core.excludesfile ~/.gitignore_global
  print_success_muted "Set global gitignore to: ~/.gitignore_global"

  print_success "Git Ignore setup completed!"
else
  print_success_muted "Git Ignore setup skipped."

fi