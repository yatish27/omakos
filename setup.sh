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
echo -e ${dim}$(get_os) $(get_os_version) ${normal}
# TODO: Add a simple instruction and explanantion of the Omakos setup

###############################################################################
# CHECK: Internet
###############################################################################
chapter "Checking internet connection…"
check_internet_connection

###############################################################################
# PROMPT: Password
###############################################################################
# chapter "Caching password…"
# ask_for_sudo

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

###############################################################################
# SETUP: Cursor
###############################################################################
chapter "Setting up Cursor…"
source ./scripts/cursor_setup.sh

###############################################################################
# SETUP: Git
###############################################################################
chapter "Setting up Git…"
source ./scripts/git_setup.sh

###############################################################################
# SETUP: Mac Settings
###############################################################################
chapter "Setting up Mac Settings…"
source ./scripts/mac_setup.sh
