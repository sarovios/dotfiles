# !/bin/bash

# Update script for dotfiles
# Run this to update your dotfiles and packages

set -e

echo "🔄 Updating dotfiles..."

# Update the dotfiles repository
git pull origin main

# Update Homebrew and packages
echo "🍺 Updating Homebrew packages..."
brew update && brew upgrade

# Clean up old versions
brew cleanup

# Update zsh plugins (if using zinit)
if command -v zinit >/dev/null 2>&1; then
    echo "🔌 Updating zsh plugins..."
    zinit update --all
fi

echo "✅ Update complete!"
