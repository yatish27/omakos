#!/usr/bin/env bash

set -e

###############################################################################
# VARIABLES
###############################################################################

reset=$'\033[0m'
dot=$'\033[31m▸ \033[0m'
dim=$'\033[2m'
blue=$'\033[34m'
yellow=$'\033[33m'

###############################################################################
# Utility Functions
###############################################################################
_print_in_color() {
  printf '%s%s%s' \
    "$(tput setaf "$2" 2> /dev/null)" \
    "$1" \
    "$(tput sgr0 2> /dev/null)"
}

###############################################################################
# Print Functions
###############################################################################

print_in_red() {
  _print_in_color "$1" 1
}

print_in_green() {
  _print_in_color "$1" 2
}

print_in_yellow() {
  _print_in_color "$1" 3
}

print_success() {
  print_in_green "  [✓] $1"$'\n'
}

print_success_muted() {
  printf '  %s[✓] %s%s\n' "$dim" "$1" "$reset"
}

print_muted() {
  printf '  %s%s%s\n' "$dim" "$1" "$reset"
}

print_warning() {
  print_in_yellow "  [!] $1"$'\n'
}

print_error() {
  print_in_red "  [𝘅] $*"$'\n'
}

###############################################################################
# Meta Checks
###############################################################################

check_internet_connection() {
  if curl --proto '=https' --proto-redir '=https' \
    --fail --silent --show-error --location --connect-timeout 10 --max-time 20 \
    --output /dev/null https://github.com; then
    print_success "Internet connection"
  else
    print_error "Cannot reach GitHub. Please check your internet connection."
    return 1
  fi
}

###############################################################################
# Prompts
###############################################################################
ask() {
  # https://djm.me/ask
  local prompt default reply

  while true; do

    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi

    # Ask the question (not using "read -p" as it uses stderr not stdout)
    echo -n "  [?] $1 [$prompt] "

    # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
    if ! IFS= read -r reply < /dev/tty; then
      print_error "Could not read confirmation. Run setup from an interactive terminal." >&2
      return 1
    fi

    # Default?
    if [ -z "$reply" ]; then
      reply=$default
    fi

    # Check if the reply is valid
    case "$reply" in
      Y* | y*) return 0 ;;
      N* | n*) return 1 ;;
    esac

  done
}

show_file_diff() {
  local file_path="$1"
  local config_file="$2"

  if [ -f "$file_path" ] && [ -f "$config_file" ]; then
    echo -e "   ${blue}📋${reset}  Showing diff between existing and new config:"
    echo -e "   ${dim}┌─────────────────────────────────────────────────────${reset}"
    if command -v diff &> /dev/null; then
      diff --color=always -u "$file_path" "$config_file" || true
    else
      echo "   ${dim}diff command not available${reset}"
    fi
    echo -e "   ${dim}└─────────────────────────────────────────────────────${reset}"
  fi
}

files_are_identical() {
  local file_path="$1"
  local config_file="$2"

  if [ -f "$file_path" ] && [ -f "$config_file" ]; then
    if command -v diff &> /dev/null; then
      diff "$file_path" "$config_file" > /dev/null 2>&1
      return $?
    else
      # Fallback: compare file sizes and content if diff is not available
      if [ "$(wc -c < "$file_path")" = "$(wc -c < "$config_file")" ]; then
        cmp "$file_path" "$config_file" > /dev/null 2>&1
        return $?
      else
        return 1
      fi
    fi
  else
    return 1
  fi
}

confirm_override() {
  local file_path="$1"
  local config_file="$2"
  local description="${3:-file}"

  if [ -f "$file_path" ]; then
    echo -e "\n   ${yellow}⚠${reset}  $description already exists at $file_path"

    # Show diff if both files exist
    show_file_diff "$file_path" "$config_file"

    if ask "Would you like to override it?" Y; then
      return 0
    else
      return 1
    fi
  else
    return 0
  fi
}

###############################################################################
# Text Formatting
###############################################################################

step() {
  printf '\n %s%s%s\n' "$dot" "$*" "$reset"
}
