<img src="./configs/images/icon.png" alt="Omakos Icon" width="100"/>

# Omakos

> This is a fork of the [Omakos project](https://github.com/yatish27/omakos) 
> Omakos turns your macOS laptop into a fully functional development machine in a single command.
> This version is a shell script to setup a new mac **VM**.

Omakos is inspired by Basecamp's [Omakub](https://github.com/basecamp/omakub) project. The name is a combination of "omakase" (お任せ, Japanese for "I leave it up to you") and "macOS", reflecting its purpose of providing a curated development environment setup for macOS.

It can be run multiple times on the same machine safely.
It installs, upgrades, or skips packages based on what is already installed on the machine.

<img src="./configs/images/screenshot_1.png" alt="screenshot" width="600"/>

## Install

You can install Omakos using one of these two methods:

### Option 1: Direct Install (Recommended)

Run this single command in your terminal:

```sh
curl -L https://raw.githubusercontent.com/amscad/omakos/vm/install.sh | bash
```

### Option 2: Manual Install

If you prefer to review the code first:

1. Download the repo:

```sh
git clone https://github.com/amscad/omakos.git && cd omakos
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

- [Ghostty](https://github.com/mitchellh/ghostty) - Modern terminal emulator

- [Mise](https://mise.jdx.dev/) for runtime version management
- [UV](https://github.com/astral-sh/uv) for Python packaging


### Productivity & Communication

- [Brave Browser](https://brave.com/) for secure web browsing
- [Claude](https://claude.ai/) for AI assistance
- [Jetbrains Toolbox](https://www.jetbrains.com/toolbox-app/)
- [VS Code](https://code.visualstudio.com)
- [Beyond Compare](https://www.scootersoftware.com)

### Fonts

- Cascadia Code
- Cascadia Mono
- Commit Mono
- DM Sans
- Fira Code
- Geist
- Geist Mono
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
./scripts/mac_setup.sh     # Only configure macOS settings
./scripts/git_setup.sh     # Only setup Git configuration
./scripts/cursor_setup.sh  # Only configure Cursor editor
./scripts/mise.sh         # Only setup mise and install configured runtimes
./scripts/dotfiles_setup.sh # Only setup dotfiles
./scripts/ssh_setup.sh    # Only configure SSH settings
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
│   ├── cursor_setup.sh     # Cursor editor configuration
│   ├── dotfiles_setup.sh   # Dotfiles management
│   ├── git_setup.sh        # Git configuration
│   ├── mac_setup.sh        # macOS system preferences
│   ├── mise.sh             # Mise runtime manager setup
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
│   ├── mise.toml          # Mise runtime versions config
│   └── rubocop.yml        # Ruby code style config
└── README.md
```

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
