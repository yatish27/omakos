#!/bin/bash

set -e

source ./scripts/utils.sh

step "Setting up hosts file..."

if [ ! -f ./configs/hosts ]; then
  print_error "Hosts file not found in configs/hosts."
  exit 1
fi

if files_are_identical "/etc/hosts" ./configs/hosts; then
  print_success_muted "Hosts file already up to date"
elif [ -f "/etc/hosts" ] && ! ask "Replace /etc/hosts with configs/hosts? The existing file will be backed up." Y; then
  print_muted "Skipping hosts file"
else
  # Stage on the same filesystem so readers always see a complete hosts file.
  (
    hosts_temp=$(sudo mktemp "/etc/.hosts.omakos.XXXXXX")
    trap 'sudo rm -f "$hosts_temp"' EXIT
    sudo install -o root -g wheel -m 644 ./configs/hosts "$hosts_temp"

    if [ -f "/etc/hosts" ]; then
      hosts_backup=$(sudo mktemp "/etc/hosts.backup.XXXXXX")
      sudo cp -p "/etc/hosts" "$hosts_backup"
      print_muted "Previous hosts file saved to $hosts_backup"
    fi

    sudo mv -f "$hosts_temp" "/etc/hosts"
  )

  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  print_success "Hosts file installed and DNS cache refreshed"
fi
