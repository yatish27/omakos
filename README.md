# Omakos

> Omakos turns your macOS laptop into a fully functional development system in a single command.

Omakos is inspired by Basecamp's [omakase](https://github.com/basecamp/omakase) project. The name is a combination of "omakase" (お任せ, Japanese for "I leave it up to you") and "macOS", reflecting its purpose of providing a curated development environment setup for macOS.

It can be run multiple times on the same machine safely.
It installs, upgrades, or skips packages based on what is already installed on the machine.

## Install

You can install Omakos using one of these two methods:

### Option 1: Direct Install (Recommended)

Run this single command in your terminal:

```sh
curl -L https://raw.githubusercontent.com/yatish27/omakos/main/install.sh | bash
```

### Option 2: Manual Install

If you prefer to review the code first:

1. Download the repo:

```sh
git clone https://github.com/yatish27/omakos.git && cd omakos
```

2. Review the scripts (please don't run scripts you don't understand):

```sh
less setup.sh
```

3. Run the setup:

```sh
./setup.sh 2>&1 | tee ~/omakos.log
```

Just follow the prompts and you'll be fine. 👌

## What it sets up

The setup process will install and configure the following tools and applications.
All packages are managed through Homebrew and defined in [`configs/Brewfile`](configs/Brewfile).

### Command Line Tools

- [XCode Command Line Tools](https://developer.apple.com/xcode/downloads/) for developer essentials
- [Git](https://git-scm.com/) with GitHub CLI (`gh`) for version control
- [Homebrew](http://brew.sh/) for managing operating system libraries
- [ZSH](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/) for a better shell experience
- [coreutils](https://www.gnu.org/software/coreutils/) for GNU file, shell and text manipulation utilities
- [curl](https://curl.se/) and [wget](https://www.gnu.org/software/wget/) for downloading files
- [fzf](https://github.com/junegunn/fzf) for command-line fuzzy finding
- [jq](https://stedolan.github.io/jq/) for JSON processing
- [btop](https://github.com/aristocratos/btop) for system resource monitoring
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) for system information display

### Development Environment

- [Cursor](https://cursor.sh/) - AI-powered code editor
- [Ghostty](https://github.com/mitchellh/ghostty) - Modern terminal emulator
- [Docker](https://www.docker.com/) for containerization
- [OrbStack](https://orbstack.dev/) for Docker and Linux development on macOS
- [PostgreSQL 17](https://www.postgresql.org/) with `libpq` for database management
- [Mise](https://mise.jdx.dev/) for runtime version management
- [Rust](https://www.rust-lang.org/) programming language
- [Ollama](https://ollama.ai/) for local AI models
- [Overmind](https://github.com/DarthSim/overmind) for process management
- [UV](https://github.com/astral-sh/uv) for Python packaging

### Productivity & Communication

- [1Password](https://1password.com/) for password management
- [Brave Browser](https://brave.com/) for secure web browsing
- [Discord](https://discord.com/) for team communication
- [Obsidian](https://obsidian.md/) for note-taking
- [Raycast](https://www.raycast.com/) for productivity enhancement
- [Rectangle](https://rectangleapp.com/) for window management
- [Claude](https://claude.ai/) for AI assistance
- [NetNewsWire](https://netnewswire.com/) for RSS reading
- [PearCleaner](https://www.pearcleaner.com/) for app uninstallation
- [VLC](https://www.videolan.org/) for media playback
- [WhatsApp](https://www.whatsapp.com/) and [Zoom](https://zoom.us/) for communication

### Fonts

- Cascadia Code & Cascadia Mono
- DM Sans
- Fira Code
- Hack
- IBM Plex Mono & IBM Plex Sans

## Features

## Code Structure

The project follows a modular structure where each component is responsible for a specific setup task. You can run any script individually if you only want to set up specific parts of your system.

```
omakos/
├── setup.sh                 # Main setup script
├── scripts/
│   ├── ascii.sh            # ASCII art for terminal output
│   ├── brew.sh             # Homebrew package installation
│   ├── cursor_setup.sh     # Cursor editor configuration
│   ├── dotfiles_setup.sh   # Dotfiles management
│   ├── git_setup.sh        # Git configuration
│   ├── mac_setup.sh        # macOS system preferences
│   ├── ssh_setup.sh        # SSH configuration
│   ├── utils.sh            # Utility functions
│   └── zsh_setup.sh        # ZSH shell setup
├── configs/
│   ├── Brewfile            # Homebrew packages list
│   ├── cursor/             # Cursor editor settings
│   ├── git/                # Git configuration files
│   ├── ssh/                # SSH configuration files
│   ├── gemrc              # Ruby gems configuration
│   ├── ghostty.conf       # Ghostty terminal config
│   └── rubocop.yml        # Ruby code style config
└── README.md
```

### Modular Scripts

Each script in the [`scripts/`](scripts/) directory can be run independently:

```sh
# Run individual scripts
./scripts/mac_setup.sh     # Only configure macOS settings
./scripts/git_setup.sh     # Only setup Git configuration
./scripts/cursor_setup.sh  # Only configure Cursor editor
```

The scripts are designed to be:

- **Independent**: Each script can run on its own
- **Idempotent**: Safe to run multiple times
- **Configurable**: Easy to modify for your needs

### Configuration Files

The [`configs/`](configs/) directory contains all config files.

## Customization

The script is designed to be customizable. You can:

- Modify the [`Brewfile`](configs/Brewfile) to add/remove packages
- Adjust macOS settings in [`scripts/mac_setup.sh`](scripts/mac_setup.sh)
- Modify the dotfiles in [`configs/`](configs/) directory

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

Inspiration and code was taken from many sources, including:

- [Formation](https://github.com/minamarkham/formation) by Mina Markham
- [Omakub](https://github.com/basecamp/omakub)
