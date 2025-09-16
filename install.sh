#!/bin/bash

# Dotfiles installation script
# This script sets up a complete development environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS"
    exit 1
fi

log_info "Starting dotfiles installation..."

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    log_warning "Please complete the Xcode Command Line Tools installation and re-run this script"
    exit 0
fi

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    log_success "Homebrew already installed"
fi

# Update Homebrew
log_info "Updating Homebrew..."
brew update

# Install packages from Brewfile
if [[ -f "Brewfile" ]]; then
    log_info "Installing packages from Brewfile..."
    brew bundle
else
    log_warning "Brewfile not found, skipping package installation"
fi

# Install Stow if not already installed
if ! command -v stow &>/dev/null; then
    log_info "Installing GNU Stow..."
    brew install stow
fi

# Create necessary directories
log_info "Creating configuration directories..."
mkdir -p ~/.config
mkdir -p ~/.ssh

# Stow dotfiles
log_info "Setting up dotfiles with Stow..."

# List of directories to stow
STOW_DIRS=("zsh" "git" "vim" "tmux")

for dir in "${STOW_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        log_info "Stowing $dir..."
        stow "$dir"
        log_success "$dir configuration linked"
    else
        log_warning "$dir directory not found, skipping"
    fi
done

# Set zsh as default shell if not already
if [[ "$SHELL" != "/bin/zsh" && "$SHELL" != "/usr/local/bin/zsh" && "$SHELL" != "/opt/homebrew/bin/zsh" ]]; then
    log_info "Setting zsh as default shell..."
    chsh -s $(which zsh)
fi

# Apply macOS defaults (skipped for now)
# if [[ -f "macos/defaults.sh" ]]; then
#     log_info "Applying macOS defaults..."
#     bash macos/defaults.sh
# fi

# SSH key setup reminder
if [[ ! -f ~/.ssh/id_rsa && ! -f ~/.ssh/id_ed25519 ]]; then
    log_warning "No SSH keys found. Generate with: ssh-keygen -t ed25519 -C 'your.email@example.com'"
fi

log_success "Dotfiles installation complete!"
log_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
