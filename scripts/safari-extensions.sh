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

    if mas get "$app_id"; then
      print_success_muted "$app_name installed or already present"
    else
      print_warning "Could not install $app_name. Sign in to the App Store and retry: mas get $app_id"
      print_muted "App Store: https://apps.apple.com/app/id$app_id"
    fi
  }

  install_safari_extension 1569813296 "1Password for Safari"
  install_safari_extension 1606897889 "Consent-O-Matic"

  # mas can reinstall paid apps, but the initial purchase must happen in the App Store.
  if mas install 1662217862; then
    print_success_muted "Wipr 2 installed or already present"
  else
    print_warning "Could not install Wipr 2. Purchase it in the App Store if needed, sign in with that Apple Account, then retry: mas install 1662217862"
    print_muted "App Store: https://apps.apple.com/app/id1662217862"
  fi
else
  print_warning "Safari extensions skipped: install mas with 'brew install mas', then rerun 'bash scripts/safari-extensions.sh'."
fi

print_muted "After installation, open Safari > Settings > Extensions, enable 1Password and Consent-O-Matic, and approve their website access."
print_muted "Open Wipr 2 and follow its setup instructions to enable its Safari extensions."
