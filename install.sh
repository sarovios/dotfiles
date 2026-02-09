#!/bin/bash

# Dotfiles installation script
# This script sets up a complete development environment
# Supports both Homebrew (macOS 13+) and MacPorts (macOS 12 and older)

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

# Get macOS version
macos_version=$(sw_vers -productVersion | cut -d '.' -f 1)
log_info "Detected macOS version: $(sw_vers -productVersion)"

# Determine package manager based on macOS version
if [ "$macos_version" -ge 13 ]; then
    PKG_MANAGER="homebrew"
    log_info "Using Homebrew (recommended for macOS 13+)"
else
    PKG_MANAGER="macports"
    log_info "Using MacPorts (recommended for macOS 12 and older)"
fi

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    log_warning "Please complete the Xcode Command Line Tools installation and re-run this script"
    exit 0
fi

# Install package manager based on detected version
if [ "$PKG_MANAGER" = "homebrew" ]; then
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

else
    # Install MacPorts if not already installed
    if ! command -v port &>/dev/null; then
        log_error "MacPorts is not installed."
        log_info "Please install MacPorts from: https://www.macports.org/install.php"
        log_info "After installing MacPorts, run this script again."
        exit 1
    else
        log_success "MacPorts already installed"
    fi

    # Update MacPorts
    log_info "Updating MacPorts..."
    sudo port selfupdate

    # Install GNU Stow first
    if ! command -v stow &>/dev/null; then
        log_info "Installing GNU Stow..."
        sudo port install stow
    fi

    # Install packages from Portfile
    if [[ -f "Portfile" ]]; then
        log_info "Installing packages from Portfile..."
        log_warning "This may take a while as MacPorts builds from source..."
        
        while IFS= read -r package; do
            # Skip comments and empty lines
            [[ -z "$package" || "$package" =~ ^# ]] && continue
            
            log_info "Installing: $package"
            sudo port install "$package" || log_warning "Failed to install $package, continuing..."
        done < <(grep -v '^#' Portfile | grep -v '^$')
        
        log_success "MacPorts packages installed"
    else
        log_warning "Portfile not found, skipping package installation"
    fi
fi

# GUI application installation notes for MacPorts users
if [ "$PKG_MANAGER" = "macports" ]; then
    log_warning ""
    log_warning "Note: GUI applications (VS Code, Docker, Chrome, etc.) need to be installed manually:"
    log_warning "  - VS Code: https://code.visualstudio.com/"
    log_warning "  - Docker Desktop: https://www.docker.com/"
    log_warning "  - Google Chrome: https://www.google.com/chrome/"
    log_warning "  - Postman: https://www.postman.com/"
    log_warning "  - Rectangle: https://rectangleapp.com/"
    log_warning "  - MonitorControl: https://github.com/MonitorControl/MonitorControl"
    log_warning "  - Maccy: https://maccy.app/"
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
