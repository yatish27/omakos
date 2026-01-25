<img src="./configs/images/icon.png" alt="Omakos Icon" width="100"/>

# Omakos

> Omakos turns your macOS laptop into a fully functional development machine in a single command.
> A shell script to setup a new mac.

Omakos is inspired by Basecamp's [Omakub](https://github.com/basecamp/omakub) project. The name is a combination of "omakase" (お任せ, Japanese for "I leave it up to you") and "macOS", reflecting its purpose of providing a curated development environment setup for macOS.

It can be run multiple times on the same machine safely.
It installs, upgrades, or skips packages based on what is already installed on the machine.

<img src="./configs/images/screenshot_1.png" alt="screenshot" width="600"/>

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
- [Git](https://git-scm.com/) for version control
- [Homebrew](http://brew.sh/) for managing operating system libraries
- [ZSH](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/) for a better shell experience
- [coreutils](https://www.gnu.org/software/coreutils/) for GNU file, shell and text manipulation utilities
- [curl](https://curl.se/) and [wget](https://www.gnu.org/software/wget/) for downloading files
- [fzf](https://github.com/junegunn/fzf) for command-line fuzzy finding
- [jq](https://stedolan.github.io/jq/) for JSON processing
- [btop](https://github.com/aristocratos/btop) for system resource monitoring
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) for system information display
- [ffmpeg](https://ffmpeg.org/) for video processing
- [gh](https://cli.github.com/) for GitHub CLI integration
- [libyaml](https://pyyaml.org/wiki/LibYAML) for YAML parsing

### Development Environment

- [Cursor](https://cursor.sh/) - AI-powered code editor
- [Neovim](https://neovim.io/) with [LazyVim](https://www.lazyvim.org/) - Modern Vim-based editor
- [Zed](https://zed.dev/) - High-performance code editor
- [Ghostty](https://github.com/mitchellh/ghostty) - Modern terminal emulator
- [Docker](https://www.docker.com/) for containerization
- [OrbStack](https://orbstack.dev/) for Docker and Linux development on macOS
- [PostgreSQL 17](https://www.postgresql.org/) with `libpq` for database management
- [Redis](https://redis.io/) for in-memory data store
- [jemalloc](https://jemalloc.net/) for memory allocation
- [vips](https://www.libvips.org/) for image processing (automatically installs configured runtimes if `~/.mise.toml` exists)
- [Ollama](https://ollama.ai/) for local AI models
- [Overmind](https://github.com/DarthSim/overmind) for process management
- [Mise](https://mise.jdx.dev/) for runtime version management. The Mise configuration is present in [mise.toml](configs/mise.toml). It installs
  - Python
  - Ruby
  - Rust
  - Go
  - Node
- [UV](https://github.com/astral-sh/uv) for Python packaging
- [pnpm](https://pnpm.io/) for Node.js package management

### Productivity & Communication

- [1Password](https://1password.com/) for password management
- [Brave Browser](https://brave.com/) for web browsing
- [ChatGPT](https://chat.openai.com/) for AI assistance
- [Claude](https://claude.ai/) for AI assistance
- [Discord](https://discord.com/) for communication
- [IINA](https://iina.io/) for media playback
- [iTerm2](https://iterm2.com/) for terminal emulation
- [LocalSend](https://localsend.org/) for cross-platform file sharing
- [NetNewsWire](https://netnewswire.com/) for RSS reading
- [Obsidian](https://obsidian.md/) for note-taking
- [Mole](https://github.com/tw93/Mole) for Mac maintenance and cleaning
- [Raycast](https://www.raycast.com/) for productivity launcher
- [Rectangle](https://rectangleapp.com/) for window management
- [Slack](https://slack.com/) for team communication
- [SuperWhisper](https://superwhisper.com/) for voice transcription
- [WhatsApp](https://www.whatsapp.com/) for messaging
- [Zoom](https://zoom.us/) for video conferencing

### Fonts

- Cascadia Code
- Cascadia Mono
- Commit Mono
- DM Sans
- Fira Code
- Geist
- Geist Mono
- Google Sans Code
- Hack
- IBM Plex Mono
- IBM Plex Sans
- Work Sans

### Enhanced macOS Settings

The setup applies developer-optimized macOS configurations including:

- **Performance**: Near-instant window animations and faster Mission Control
- **Finder**: Opens to home directory, searches current folder by default, shows hidden files
- **Text Editing**: Key repeat enabled in all apps, faster cursor movement
- **Screenshots**: Organized in `~/Desktop/Screenshots/` folder without shadows
- **Trackpad**: Three-finger drag enabled for better window management
- **Keyboard**: Fastest repeat rates for efficient coding
- **System**: Disabled automatic corrections, expanded dialogs, local saves by default

## Features

### Modular Scripts

Each script in the [`scripts/`](scripts/) directory can be run independently:

```sh
# Run individual scripts
./scripts/mac.sh       # Only configure macOS settings
./scripts/git.sh       # Only setup Git configuration
./scripts/cursor.sh    # Only configure Cursor editor
./scripts/nvim.sh      # Only configure Neovim with LazyVim
./scripts/zed.sh       # Only configure Zed editor
./scripts/mise.sh      # Only setup mise and install configured runtimes
./scripts/rubocop.sh   # Only setup Rubocop configuration
./scripts/gemrc.sh     # Only setup Gem configuration
./scripts/irbrc.sh     # Only setup IRB configuration
./scripts/zshrc.sh     # Only setup Zsh configuration
./scripts/ssh.sh       # Only configure SSH settings
```

The scripts are designed to be:

- **Independent**: Each script can run on its own
- **Idempotent**: Safe to run multiple times
- **Configurable**: Easy to modify for your needs

## Code Structure

The project follows a modular structure where each component is responsible for a specific setup task. You can run any script individually if you only want to set up specific parts of your system.

```
omakos/
├── setup.sh                 # Main setup script
├── scripts/
│   ├── ascii.sh            # ASCII art for terminal output
│   ├── brew.sh             # Homebrew package installation
│   ├── cursor.sh           # Cursor editor configuration
│   ├── gemrc.sh            # Gem configuration
│   ├── ghostty.sh          # Ghostty terminal configuration
│   ├── git.sh              # Git configuration
│   ├── irbrc.sh            # IRB configuration
│   ├── mac.sh              # macOS system preferences
│   ├── mise.sh             # Mise runtime manager setup
│   ├── nvim.sh             # Neovim configuration
│   ├── rubocop.sh          # Rubocop configuration
│   ├── ssh.sh              # SSH configuration
│   ├── utils.sh            # Utility functions
│   ├── zed.sh              # Zed editor configuration
│   ├── zsh.sh              # ZSH shell setup
│   └── zshrc.sh            # Zshrc configuration
├── configs/
│   ├── Brewfile            # Homebrew packages list
│   ├── cursor/             # Cursor editor settings
│   ├── git/                # Git configuration files
│   ├── nvim/               # Neovim configuration with LazyVim
│   ├── ssh/                # SSH configuration files
│   ├── zed/                # Zed editor settings
│   ├── gemrc              # Ruby gems configuration
│   ├── ghostty.conf       # Ghostty terminal config
│   ├── irbrc              # IRB (Interactive Ruby) configuration
│   ├── mise.toml          # Mise runtime versions config
│   ├── rubocop.yml        # Ruby code style config
│   └── zshrc              # Zsh shell configuration
└── README.md
```

### Configuration Files

The [`configs/`](configs/) directory contains all config files.

## Customization

The script is designed to be customizable. You can:

- Modify the [`Brewfile`](configs/Brewfile) to add/remove packages
- Adjust macOS settings in [`scripts/mac.sh`](scripts/mac.sh)
- Modify the configuration files in [`configs/`](configs/) directory


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

Inspiration and code was taken from many sources, including:

- [Formation](https://github.com/minamarkham/formation) by Mina Markham
- [Omakub](https://github.com/basecamp/omakub)
