#!/bin/bash

###############################################################################
# ERROR: Let the user know if the script fails
###############################################################################

# Exit handler - runs if script fails
trap 'if [ $? -ne 0 ]; then
  echo -e "\n   ❌ Omakos setup failed"
  exit $?
fi' EXIT

set -e

# Source utility functions
source ./scripts/utils.sh

chapter() {
  local fmt="$1"
  shift
  printf "\n✦  ${bold}$((count++)). $fmt${normal}\n└─────────────────────────────────────────────────────○\n" "$@"
}

###############################################################################
# Initial Ascii Art and Introduction
###############################################################################

source ./scripts/ascii.sh

printf "\nWelcome to Omakos! 🚀\n"
printf "Omakos turns your new mac laptop into a full configured development system in a single command.\n"
printf "It is safe to rerun this multiple times.\n"
printf "You can cancel at any time by pressing ctrl+c.\n"
printf "Let's get started!\n"

###############################################################################
# CHECK: Internet
###############################################################################
chapter "Checking internet connection…"
check_internet_connection

###############################################################################
# PROMPT: Password
###############################################################################
chapter "Caching password…"
ask_for_sudo

###############################################################################
# INSTALL: Dependencies
###############################################################################
chapter "Installing Dependencies…"

# -----------------------------------------------------------------------------
# XCode
# -----------------------------------------------------------------------------
os=$(sw_vers -productVersion | awk -F. '{print $1 "." $2}')
if softwareupdate --history | grep --silent "Command Line Tools.*${os}"; then
  print_success_muted 'Command-line tools already installed. Skipping'
else
  step 'Installing Command-line tools...'
  in_progress=/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  touch ${in_progress}
  product=$(softwareupdate --list | awk "/\* Command Line.*${os}/ { sub(/^   \* /, \"\"); print }")
  if ! softwareupdate --verbose --install "${product}"; then
    echo 'Installation failed.' 1>&2
    rm ${in_progress}
    exit 1
  fi
  rm ${in_progress}
  print_success 'Installation succeeded.'
fi

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------
if ! [ -x "$(command -v brew)" ]; then
  step "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ "$(uname -p)" == "arm" ]]; then
    # Apple Silicon M1/M2 Macs
    export PATH=/opt/homebrew/bin:$PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    # Intel Macs
    export PATH=/usr/local/bin:$PATH
  fi
  print_success "Homebrew installed!"
else
  print_success_muted "Homebrew already installed. Updating Homebrew formulae…"
  brew update --quiet >/dev/null 2>&1
fi

###############################################################################
# INSTALL: Homebrew Packages
###############################################################################
chapter "Installing Homebrew Packages…"
source ./scripts/brew.sh

###############################################################################
# INSTALL: Setup ZSH and oh-my-zsh
###############################################################################
chapter "Setting up ZSH…"
source ./scripts/zsh.sh

###############################################################################
# SETUP: Cursor
###############################################################################
chapter "Setting up Cursor…"
source ./scripts/cursor.sh

###############################################################################
# SETUP: Neovim
###############################################################################
chapter "Setting up Neovim…"
source ./scripts/nvim.sh

###############################################################################
# SETUP: Zed
###############################################################################
chapter "Setting up Zed…"
source ./scripts/zed.sh

###############################################################################
# SETUP: Git
###############################################################################
chapter "Setting up Git…"
source ./scripts/git.sh

###############################################################################
# SETUP: SSH
###############################################################################
chapter "Setting up SSH…"
source ./scripts/ssh.sh

###############################################################################
# SETUP: Rubocop
###############################################################################
chapter "Setting up Rubocop…"
source ./scripts/rubocop.sh

###############################################################################
# SETUP: Gemrc
###############################################################################
chapter "Setting up Gem configuration…"
source ./scripts/gemrc.sh

###############################################################################
# SETUP: IRB
###############################################################################
chapter "Setting up IRB configuration…"
source ./scripts/irbrc.sh

###############################################################################
# SETUP: Zshrc
###############################################################################
chapter "Setting up Zsh configuration…"
source ./scripts/zshrc.sh

###############################################################################
# SETUP: Ghostty
###############################################################################
chapter "Setting up Ghostty…"
source ./scripts/ghostty.sh

###############################################################################
# SETUP: Development Tools with mise
###############################################################################
chapter "Setting up Development Tools…"
source ./scripts/mise.sh

###############################################################################
# SETUP: Mac Settings
###############################################################################
chapter "Setting up Mac Settings…"
source ./scripts/mac.sh

###############################################################################
# SETUP: Complete
###############################################################################
chapter "Setup Complete!"
print_success "Your Mac is now ready to use! 🎉"
print_success_muted "You may need to restart your computer for all changes to take effect."
