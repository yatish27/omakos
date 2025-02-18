#!/bin/bash

echo "🚀 Starting MacOS development environment setup..."

# Check if Homebrew is already installed
if command -v brew >/dev/null 2>&1; then
  echo "✅ Homebrew is already installed"
else
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs in current session
  if [[ $(uname -m) == "arm64" ]]; then
    echo "🔧 Configuring Homebrew for Apple Silicon..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# Update Homebrew
echo "🔄 Updating Homebrew..."
brew update

echo "✨ Homebrew installation complete!"

# Install git if not already installed
if command -v git >/dev/null 2>&1; then
  echo "✅ Git is already installed"
else
  echo "📦 Installing git..."
  brew install git
fi

# Clone repository in the home folder
echo "📥 Cloning omakos repository into the home folder..."
cd ~
git clone https://github.com/yatish27/omakos.git
cd omakos

# Setup the macOS settings
echo "🔧 Running mac setup script..."
./mac_setup.sh

# Install packages from Brewfile
echo "📦 Installing packages from Brewfile..."
brew bundle

# Setup Cursor
echo "🎯 Setting up Cursor..."
chmod +x cursor_setup.sh
./cursor_setup.sh

# Copy rubocop config
echo "📝 Setting up Rubocop configuration..."
cp configs/rubocop.yml ~/.rubocop.yml
echo "✅ Rubocop configuration copied to home directory"

# Copy gemrc config
echo "💎 Setting up Ruby gems configuration..."
cp configs/gemrc ~/.gemrc
echo "✅ Gemrc configuration copied to home directory"

# Copy Ghostty config
echo "👻 Setting up Ghostty terminal configuration..."
mkdir -p ~/.config/ghostty
cp configs/ghostty.conf ~/.config/ghostty/config
echo "✅ Ghostty configuration copied to config directory"

# Setup Git configuration
echo "🔧 Setting up Git configuration..."
cp configs/git/gitconfig ~/.gitconfig
echo "✅ Git configuration copied to home directory"

# Copy fish config
echo "🐟 Setting up Fish shell configuration..."
mkdir -p ~/.config/fish
cp configs/fish/config.fish ~/.config/fish/config.fish
echo "✅ Fish configuration copied to config directory"

# Set default shell to fish
if ! grep -q "$(which fish)" /etc/shells; then
  echo "$(which fish)" | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"
echo "✅ Default shell set to Fish"

# Copy SSH config
echo "🔑 Setting up SSH configuration..."
if [ ! -d ~/.ssh ]; then
  mkdir -p ~/.ssh
fi
if [ -f configs/ssh/config ]; then
  cp configs/ssh/config ~/.ssh/
else
  echo "❌ configs/ssh/config: No such file or directory"
fi
echo "✅ SSH configuration copied to .ssh directory"
