#!/bin/bash

# Backup script for important dotfiles
# Creates timestamped backups of current configurations

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

echo "📦 Creating backup in $BACKUP_DIR..."

mkdir -p "$BACKUP_DIR"

# Backup existing configurations (current locations after our changes)
files_to_backup=(
    "$HOME/.zshenv"                        # Bootstrap file (must stay in home)
    "$HOME/.config/zsh"                    # Zsh configuration directory
    "$HOME/.config/git"                    # Git configuration directory
    "$HOME/.config/starship"               # Starship prompt config directory
    "$HOME/.config/tmux"                   # Tmux configuration directory
    "$HOME/.config/nvim"                   # Neovim configuration (if exists)
    "$HOME/.local/share/zsh/history"       # Zsh history (new location)
    "$HOME/.cache/zsh"                     # Zsh cache directory
    "$HOME/.ssh/config"                    # SSH config (if exists)
)

for file in "${files_to_backup[@]}"; do
    if [ -e "$file" ]; then
        echo "Backing up $file..."
        # Preserve directory structure in backup
        parent_dir="$BACKUP_DIR/$(dirname "${file#$HOME/}")"
        mkdir -p "$parent_dir"
        cp -r "$file" "$parent_dir/"
    else
        echo "⚠️  Skipping $file (not found)"
    fi
done

echo ""
echo "✅ Backup complete: $BACKUP_DIR"
echo "📁 Backup contains your current configuration state"
echo ""
echo "📋 Backup includes:"
echo "   • Current XDG-compliant configurations"
echo "   • Zsh history and cache files"
echo ""
echo "💡 To restore: cp -r $BACKUP_DIR/* ~/"
