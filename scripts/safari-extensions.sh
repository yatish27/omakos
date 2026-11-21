#!/bin/bash

set -e

source ./scripts/utils.sh

step "Installing Safari extensions from the Mac App Store..."

if command -v mas >/dev/null 2>&1; then
  print_muted "Sign in to the App Store first; Apple may ask you to authenticate the downloads."

  # mas get supports free apps that are not yet in the account's purchase history.
  install_safari_extension() {
    local app_id="$1"
    local app_name="$2"
    local install_command="${3:-get}"

    if mas "$install_command" "$app_id"; then
      print_success_muted "$app_name installed or already present"
    else
      if [ "$install_command" = install ]; then
        print_warning "Could not install $app_name. Purchase it in the App Store if needed, sign in with that Apple Account, then retry: mas install $app_id"
      else
        print_warning "Could not install $app_name. Sign in to the App Store and retry: mas get $app_id"
      fi
      print_muted "App Store: https://apps.apple.com/app/id$app_id"
    fi
  }

  install_safari_extension 1569813296 "1Password for Safari"
  install_safari_extension 1606897889 "Consent-O-Matic"
  install_safari_extension 6745342698 "uBlock Origin Lite"

  # mas can reinstall paid apps, but the initial purchase must happen in the App Store.
  install_safari_extension 1474335294 "GoodLinks" install
  install_safari_extension 1662217862 "Wipr 2" install
else
  print_warning "Safari extensions skipped: install mas with 'brew install mas', then rerun 'bash scripts/safari-extensions.sh'."
fi

print_muted "After installation, open Safari > Settings > Extensions and enable 1Password, Consent-O-Matic, uBlock Origin Lite, and GoodLinks."
print_muted "Approve website access when prompted."
print_muted "Open Wipr 2 and follow its setup instructions to enable its Safari extensions."

# Safari keeps extension storage private; use uBOL's supported append import.
ubol_filters_file="$(pwd)/configs/ublock-origin-lite/custom-filters.txt"
if [ -s "$ubol_filters_file" ]; then
  step "uBlock Origin Lite custom filters: manual import required"
  print_muted "Open uBlock Origin Lite's dashboard from its Safari toolbar button."
  print_muted "Choose Custom filters > Import / Export > Import and append..., then select:"
  print_muted "$ubol_filters_file"
  print_muted "This adds the bundled filters to your existing filters. Reload affected webpages afterward."
else
  print_warning "uBlock Origin Lite custom filter file not found or empty: $ubol_filters_file"
fi
