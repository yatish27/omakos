#!/bin/bash

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

# Setup gitconfig if it doesn't exist or user agrees to override
if [ ! -f "$HOME/.gitconfig" ] || ask "A .gitconfig file already exists. Would you like to override it?" Y; then
  print_muted "Copying gitconfig from configs/git/gitconfig..."
  cp configs/git/gitconfig ~/.gitconfig
  print_success_muted "Copied gitconfig file"

  # Prompt for Git user information and override existing settings
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
