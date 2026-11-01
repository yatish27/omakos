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

# Decide whether to replace the config before asking for identity information.
gitconfig_setup=false

# Setup gitconfig if it doesn't exist or user agrees to override
if [ ! -f "$HOME/.gitconfig" ]; then
  gitconfig_setup=true
elif files_are_identical "$HOME/.gitconfig" "configs/git/gitconfig"; then
  print_success_muted "Git configuration already up to date"
  gitconfig_setup=true
elif confirm_override "$HOME/.gitconfig" "configs/git/gitconfig" ".gitconfig file"; then
  gitconfig_setup=true
else
  print_success_muted "Git configuration skipped."
fi

# Prompt for Git user information only if gitconfig is set up
if [ "$gitconfig_setup" = true ]; then
  print_muted "Setting up Git user information..."

  if ! IFS= read -r -p "Enter your Git display name: " git_name </dev/tty ||
     ! IFS= read -r -p "Enter your Git email: " git_email </dev/tty; then
    print_error "Could not read Git identity. Run setup from an interactive terminal."
    exit 1
  fi
  if [[ ! "$git_name" =~ [^[:space:]] ]] || [[ ! "$git_email" =~ [^[:space:]] ]]; then
    print_error "Git name and email must not be empty."
    exit 1
  fi

  # Publish only a complete config, leaving the current one intact on failure.
  (
    git_config_temp=$(mktemp "$HOME/.gitconfig.omakos.XXXXXX")
    trap 'rm -f "$git_config_temp"' EXIT
    cp configs/git/gitconfig "$git_config_temp"
    git config --file "$git_config_temp" user.name "$git_name"
    git config --file "$git_config_temp" user.email "$git_email"
    mv "$git_config_temp" "$HOME/.gitconfig"
  )

  print_success "Git setup completed!"
else
  print_success_muted "Git setup completed (configuration skipped)."
fi
