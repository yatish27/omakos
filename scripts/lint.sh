#!/bin/bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Include new files so local checks cover work that has not been committed yet.
shell_scripts=()
while IFS= read -r -d '' script; do
  shell_scripts+=("$script")
done < <(git ls-files --cached --others --exclude-standard -z -- '*.sh')

for script in "${shell_scripts[@]}"; do
  bash -n "$script"
done
shellcheck -x "${shell_scripts[@]}"
shfmt -i 2 -ci -sr -d "${shell_scripts[@]}"
zsh -n configs/zshrc
ruby -c configs/Brewfile
ruby -c configs/irbrc
git config --file configs/git/gitconfig --list > /dev/null
# UseKeychain is an Apple extension; permit it when validating on Linux.
ssh -G -T -F configs/ssh/config -o IgnoreUnknown=UseKeychain github.com > /dev/null
