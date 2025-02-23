#! /bin/bash

source ./scripts/utils.sh

step "Installing Homebrew packages from configs/Brewfile"
echo ""
echo "--------------------------------------------------------"
brew bundle --file=configs/Brewfile
echo "--------------------------------------------------------"
print_success "Homebrew packages installed!"
