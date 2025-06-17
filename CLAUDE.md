# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Omakos is a macOS development environment setup script inspired by Basecamp's Omakub. It transforms a new Mac into a fully configured development machine with a single command. The project is designed to be idempotent (safe to run multiple times) and modular (individual scripts can be run independently).

## Architecture

The project follows a modular shell script architecture:

- **Entry Points**: `install.sh` (downloads and runs setup) and `setup.sh` (main orchestrator)
- **Core Scripts**: Located in `scripts/` directory, each handling a specific setup aspect
- **Configuration**: All config files stored in `configs/` directory
- **Utilities**: Common functions and styling in `scripts/utils.sh`

### Key Components

- `setup.sh`: Main orchestrator that calls all setup scripts in sequence
- `scripts/utils.sh`: Utility functions for printing, file operations, and system checks
- `scripts/brew.sh`: Installs Homebrew packages from `configs/Brewfile`
- `scripts/zsh_setup.sh`: Configures ZSH with Oh My Zsh
- `scripts/cursor_setup.sh`: Sets up Cursor editor with custom settings
- `scripts/git_setup.sh`: Git configuration setup
- `scripts/ssh_setup.sh`: SSH configuration
- `scripts/dotfiles_setup.sh`: Symlinks dotfiles from configs
- `scripts/mise.sh`: Sets up Mise runtime manager and installs configured languages
- `scripts/mac_setup.sh`: macOS system preferences configuration

## Key Commands

### Running the Setup
```bash
# Full setup (recommended)
./setup.sh 2>&1 | tee ~/omakos.log

# Individual scripts can be run independently
./scripts/brew.sh           # Install Homebrew packages only
./scripts/cursor_setup.sh   # Configure Cursor editor only
./scripts/git_setup.sh      # Setup Git configuration only
./scripts/mise.sh          # Setup development runtimes only
```

### Development Tools Installed

The setup installs these development tools via Mise (defined in `configs/mise.toml`):
- **Node.js**: LTS version
- **Python**: Latest version  
- **Ruby**: Latest version
- **Rust**: Latest version
- **Go**: Latest version

## Configuration Files

### Package Management
- `configs/Brewfile`: Defines all Homebrew packages, casks, and fonts to install
- `configs/mise.toml`: Runtime version management configuration

### Development Tools
- `configs/cursor/settings.json`: Cursor editor settings optimized for Ruby/Rails development
- `configs/git/gitconfig`: Git configuration template
- `configs/ghostty.conf`: Terminal emulator configuration
- `configs/zshrc`: ZSH shell configuration

### Development Environment Settings
- Ruby LSP configured for Mise runtime management
- Rubocop integration for code formatting
- Tailwind CSS support for ERB templates
- Auto-save and format-on-save enabled

## Important Patterns

### Error Handling
All scripts use `set -e` for immediate exit on errors and include trap handlers for cleanup.

### User Interaction
Scripts use utility functions from `utils.sh` for consistent user prompts and colored output.

### Idempotency
Scripts check for existing installations before attempting to install/configure, making them safe to re-run.

### Modular Design  
Each script in `scripts/` can be executed independently, allowing users to run only specific setup components.

## File Operations

The project uses a consistent pattern for file linking and backup:
- `_link_file()` function handles symlinking with user prompts for conflicts
- Backup options available for existing files
- Skip functionality for files that are already correctly linked