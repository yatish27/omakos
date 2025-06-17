#!/bin/bash

# Source utility functions
source ./scripts/utils.sh

# Set macOS preferences
step "Customizing macOS system preferences..."

# Keyboard settings
step "Setting faster keyboard repeat rates..."
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1         # normal minimum is 2 (30 ms)
print_success_muted "Keyboard repeat rates configured"

# Finder preferences
step "Configuring enhanced Finder settings..."
defaults write com.apple.finder AppleShowAllFiles YES
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
print_success_muted "Finder preferences configured"

# System preferences
step "Configuring enhanced system and trackpad settings..."
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
print_success_muted "System preferences configured"

# Text and input preferences
step "Configuring enhanced text and input settings..."
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSTextMovementDefaultKeyTimeout -float 0.03
print_success_muted "Text input preferences configured"

# Save and print dialogs
step "Expanding save and print dialogs by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
print_success_muted "Save and print dialogs configured"

# Performance and UI enhancements
step "Optimizing window and UI performance..."
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0
print_success_muted "Performance optimizations configured"

# Screenshot settings
step "Configuring enhanced screenshot settings..."
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture "include-date" -bool "true"
defaults write com.apple.screencapture location -string "~/Desktop/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true
print_success_muted "Screenshot settings configured"

# .DS_Store settings
step "Preventing .DS_Store file creation on network and USB volumes..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
print_success_muted ".DS_Store settings configured"

# Show Library folder
step "Making Library folder visible in home directory..."
chflags nohidden ~/Library
print_success_muted "Library folder made visible"

# Dock settings
step "Removing Dock animation delays and clearing default apps..."
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock springboard-show-duration -int 0
defaults write com.apple.dock springboard-hide-duration -int 0
defaults write com.apple.dock springboard-page-duration -int 0
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock mru-spaces -bool false
print_success_muted "Dock preferences configured"

# iCloud default save
step "Setting default save location to local disk instead of iCloud..."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
print_success_muted "Default save location configured"

# Disable Apple Intelligence
step "Disabling Apple Intelligence..."
defaults write com.apple.CloudSubscriptionFeatures.optIn "545129924" -bool "false"
print_success_muted "Apple Intelligence disabled"

# Restart affected applications
step "Applying changes by restarting system components..."
killall Dock
killall Finder
killall SystemUIServer
print_success_muted "Applications restarted"

echo ""
print_success "macOS settings have been updated successfully!"
