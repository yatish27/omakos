# Interactive shell configuration
if status is-interactive then
    # Commands to run in interactive sessions can go here
end

# Homebrew configuration
eval "$(/opt/homebrew/bin/brew shellenv)"

# Ruby configuration
export LDFLAGS="-L$(brew --prefix libyaml)/lib"
export CPPFLAGS="-I$(brew --prefix libyaml)/include"
export RUBY_YJIT_ENABLE=1
export RUBY_CONFIGURE_OPTS=--enable-yjit

# Development environment setup
# Initialize mise (previously rtx) for version management
mise activate fish | source

fzf --fish | source

# PostgreSQL path configuration
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"