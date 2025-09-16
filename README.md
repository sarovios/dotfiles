# Dotfiles

Personal dotfiles for setting up a development environment quickly and consistently across machines.

## Features

- **Shell Configuration**: Custom zsh setup with aliases, functions, and Starship prompt
- **Git Configuration**: Modern git settings with Delta pager and useful aliases
- **Development Tools**: Neovim configuration with plugins and modern terminal setup
- **Package Management**: Automated installation of essential tools via Homebrew
- **GNU Stow**: Symlink management for clean, modular organization
- **Modular Installation**: Install individual components or everything at once

## Quick Setup

```bash
# Clone the repository
git clone https://github.com/sotirisbeis/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the installation script
./install.sh
```

## Manual Setup

Install components individually:

```bash
# Install Homebrew packages
brew bundle

# Install individual configurations
stow git        # Git configuration
stow zsh        # Shell configuration  
stow nvim       # Neovim configuration
stow tmux       # Terminal multiplexer
stow starship   # Shell prompt

# Or install multiple at once
stow git zsh nvim tmux starship
```

## Structure

```
dotfiles/
├── .stowrc              # Stow configuration (targets ~)
├── README.md            # This file
├── install.sh           # Automated setup script
├── Brewfile             # Homebrew packages
├── git/                    # Git configuration
│   └── .config/
│       └── git/
│           ├── config      # Git user settings, aliases, and preferences
│           └── gitignore_global
├── neovim/                 # Neovim configuration (bring your own)
├── starship/              # Cross-shell prompt
│   └── .config/
│       └── starship.toml
├── tmux/                  # Terminal multiplexer
│   └── .config/
│       └── tmux/
│           └── tmux.conf
└── zsh/                   # Shell configuration
    ├── .zshenv            # XDG base directory specification
    └── .config/
        └── zsh/
            ├── .zshrc     # Main shell configuration
            ├── aliases.zsh
            └── functions.zsh
└── scripts/             # Utility scripts
    ├── update.sh       # Update packages and plugins
    └── backup.sh       # Backup existing configs
```

## Customization

The configuration is modular and easy to customize:

### Git Configuration
- **Personal Details**: Already configured with your name (Sotiris Beis) and email
- **Editor**: Set to VS Code (`code --wait`)
- **GitHub Username**: sotirisbeis
- **Modern Workflow**: Uses rebase on pull, auto-stash, and Delta pager

### Shell (Zsh)
- **Plugin Manager**: Uses Zinit for fast plugin loading
- **Prompt**: Starship with custom configuration
- **Aliases**: Comprehensive set of shortcuts for git, docker, kubernetes, etc.
- **Functions**: Useful shell functions for development

### Development Tools
- **Neovim**: Your custom nvim configuration
- **Tmux**: Vim-like keybindings and modern settings
- **Packages**: Curated list of development tools in Brewfile

## Managing Configurations

### Add New Tools
1. Create a new directory (e.g., `newtool/`)
2. Structure it to match your home directory: `newtool/.config/newtool/config`
3. Install with: `stow newtool`

### Update Everything
```bash
./scripts/update.sh     # Updates packages and plugins
```

### Backup Before Changes
```bash
./scripts/backup.sh     # Creates timestamped backup
```

### Remove Configurations
```bash
stow -D git            # Remove git config
stow -D zsh nvim       # Remove multiple configs
```

## Dependencies

- macOS (some scripts are macOS-specific)
- [Homebrew](https://brew.sh/) (installed automatically by install.sh)
- [GNU Stow](https://www.gnu.org/software/stow/) (installed via Homebrew)

## Key Features

### Git Configuration
- **Delta Pager**: Beautiful syntax-highlighted diffs
- **Modern Aliases**: Shortcuts for common git operations
- **Safe Defaults**: Rebase on pull, auto-stash, force-with-lease
- **Global Gitignore**: Handles OS and editor files automatically

### Shell Setup
- **Zinit Plugin Manager**: Fast, efficient zsh plugin loading
- **Starship Prompt**: Modern, informative command prompt
- **Rich Aliases**: Shortcuts for git, docker, kubernetes, and more
- **Custom Functions**: Useful utilities for development workflow

### Development Environment
- **Neovim**: Your personal nvim setup and configuration
- **Tmux**: Terminal multiplexer with vim-like navigation
- **Homebrew**: Curated package list for development tools

## Repository Setup

To use this as your own dotfiles repository:

1. Fork this repository
2. Update the git configuration with your details:
   - Name and email in `git/.config/git/config`
   - GitHub username in the same file
3. Customize configurations to your preferences
4. Update the clone URL in this README

## License

MIT License - feel free to use and modify as needed.
