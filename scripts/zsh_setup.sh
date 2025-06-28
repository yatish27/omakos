#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# set zsh as default shell
if ! command -v zsh &>/dev/null; then
  step "Setting ZSH as default shell…"
  chsh -s $(which zsh)
  print_success "ZSH set as default shell!"
fi

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  print_success_muted "oh-my-zsh already installed. Skipping"
else
  step "Installing oh-my-zsh…"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  print_success "oh-my-zsh installed!"
fi