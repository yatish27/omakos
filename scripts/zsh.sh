#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

# Use the system Zsh, which macOS already registers as a valid login shell.
zsh_path=/bin/zsh
if [ ! -x "$zsh_path" ]; then
  print_error "The system ZSH executable is missing at $zsh_path."
  exit 1
fi
if [ "${SHELL:-}" != "$zsh_path" ]; then
  step "Setting ZSH as default shell…"
  chsh -s "$zsh_path"
  print_success "ZSH set as default shell!"
fi

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  print_success_muted "oh-my-zsh already installed. Skipping"
else
  step "Installing oh-my-zsh…"
  # Keep download and execution separate so a failed/partial download is fatal.
  ohmyzsh_installer=$(curl --proto '=https' --proto-redir '=https' -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$ohmyzsh_installer"
  print_success "oh-my-zsh installed!"
fi
