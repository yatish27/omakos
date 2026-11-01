#!/bin/bash

set -e

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
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
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
defaults write com.apple.dock workspaces-swoosh-animation-off -bool true
print_success_muted "Performance optimizations configured"

step "Reducing interface motion..."
if defaults write com.apple.universalaccess reduceMotion -bool true; then
  print_success_muted "Reduce Motion enabled"
else
  print_warning "Search System Settings for Reduce Motion and enable it manually; macOS blocked the preference write."
fi

# Opaque system surfaces (macOS has no supported switch to remove Liquid Glass).
step "Reducing interface transparency..."
if defaults write com.apple.universalaccess reduceTransparency -bool true; then
  print_success_muted "Reduce Transparency enabled"
else
  print_warning "Enable Reduce Transparency in System Settings > Accessibility > Display. macOS blocked the preference write."
fi

# Hide widgets in both desktop modes without deleting their saved configuration.
step "Hiding desktop widgets..."
defaults write com.apple.WindowManager StandardHideWidgets -bool true
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true
print_success_muted "Desktop and Stage Manager widgets hidden"

# Safari's preferences can be protected by Full Disk Access.
step "Removing Safari start-page sections..."
safari_settings_applied=true
for safari_setting in ShowFavorites ShowFrequentlyVisitedSites ShowHighlightsInFavorites \
  ShowPrivacyReportInFavorites ShowReadingListInFavorites ShowCloudTabsInFavorites \
  ShowBackgroundImageInFavorites ShowFavoritesUnderSmartSearchField; do
  if ! defaults write com.apple.Safari "$safari_setting" -bool false; then
    safari_settings_applied=false
  fi
done
# 1 = Empty Page, so new tabs/windows stay empty even if Safari adds new sections.
for safari_setting in NewTabBehavior NewWindowBehavior; do
  if ! defaults write com.apple.Safari "$safari_setting" -int 1; then
    safari_settings_applied=false
  fi
done
if [ "$safari_settings_applied" = true ]; then
  print_success_muted "Safari start-page sections hidden; new tabs and windows open empty"
  print_muted "Restart Safari to apply these settings."
else
  print_warning "Safari blocked some settings. Grant your terminal Full Disk Access and rerun, or disable start-page sections with Edit and choose Empty Page for new tabs/windows in Safari > Settings > General."
fi

# Screenshot settings
step "Configuring enhanced screenshot settings..."
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture "include-date" -bool "true"
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
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
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
killall NotificationCenter 2>/dev/null || true
killall WindowManager 2>/dev/null || true
print_success_muted "Applications restarted"

echo ""
print_success "macOS settings applied. Review any warnings above; log out and back in for all changes to take effect."
