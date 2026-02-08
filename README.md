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
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the installation script
./install.sh
```

**📋 For detailed setup instructions, see [SETUP.md](SETUP.md)**

## ⚠️ Important: Personalize Before Use

After installation, update these files with your personal information:

### 1. Git Configuration ([git/.config/git/config](git/.config/git/config))
```bash
# Edit the user section
[user]
    name = Your Name              # Update with your name
    email = your.email@domain.com # Update with your email
```

### 2. Environment Variables ([zsh/.zshenv](zsh/.zshenv))
- **SSL Certificates**: If you need custom SSL certificates (e.g., corporate proxy), place them in `~/.certs/` and the config will automatically detect them
- **Company Variables**: Uncomment and configure any company-specific variables like `DBT_SNOWFLAKE_AD_USER_ID`
- **Adjust Paths**: Review PATH modifications and adjust for your specific setup (JetBrains, npm, etc.)

### 3. Review Brewfile
The [Brewfile](Brewfile) contains packages to install. Review and:
- Uncomment optional applications you want (VS Code, Docker, browsers, etc.)
- Remove packages you don't need
- Add your own preferred tools

## Manual Setup

Install components individually:

```bash
# Install Homebrew packages
brew bundle

# Install individual configurations
stow git        # Git configuration
stow zsh        # Shell configuration  
stow tmux       # Terminal multiplexer
stow starship   # Shell prompt
stow iterm2     # iTerm2 terminal
stow vscode     # VS Code settings and keybindings

# Or install multiple at once
stow git zsh tmux starship iterm2 vscode
```

## Structure

```
dotfiles/
├── .stowrc                 # Stow configuration (targets ~)
├── README.md               # This file
├── SETUP.md                # Detailed setup checklist
├── install.sh              # Automated setup script
├── Brewfile                # Homebrew packages and applications
├── git/                    # Git configuration
│   └── .config/
│       └── git/
│           ├── config              # Git user settings, aliases, and preferences
│           └── gitignore_global    # Global gitignore patterns
├── iterm2/                 # iTerm2 terminal configuration
│   └── .config/
│       └── iterm2/
│           └── com.googlecode.iterm2.plist  # iTerm2 preferences
├── starship/               # Cross-shell prompt
│   └── .config/
│       └── starship/
│           └── starship.toml       # Starship configuration
├── tmux/                   # Terminal multiplexer
│   └── .config/
│       └── tmux.conf               # Tmux configuration
├── vscode/                 # VS Code configuration
│   ├── .config/
│   │   └── Code/
│   │       └── User/
│   │           ├── settings.json       # VS Code settings
│   │           └── keybindings.json    # Custom keybindings
│   ├── extensions.txt              # List of VS Code extensions
│   ├── install-extensions.sh       # Script to install extensions
│   └── README.md                   # VS Code setup instructions
├── zsh/                    # Shell configuration
│   ├── .zshenv                     # XDG base directory & environment
│   └── .config/
│       └── zsh/
│           ├── .zshrc              # Main shell configuration
│           ├── aliases.zsh         # Command aliases
│           └── functions.zsh       # Custom shell functions
└── scripts/                # Utility scripts
    ├── update.sh                   # Update packages and plugins
    └── backup.sh                   # Backup existing configs
```

## Customization

**Before first use on a new machine, be sure to personalize:**
- Git user name and email in [git/.config/git/config](git/.config/git/config)
- GitHub username in [git/.config/git/config](git/.config/git/config)
- Company-specific environment variables in [zsh/.zshenv](zsh/.zshenv)
- SSL certificate paths if needed for corporate environments

The configuration is modular and easy to customize further:

### Git Configuration
- **Personal Details**: Update with your name and email (see personalization section above)
- **Editor**: Set to VS Code (`code --wait`) - change to `nvim`, `vim`, or your preferred editor
- **GitHub Username**: Update to your GitHub username
- **Modern Workflow**: Uses rebase on pull, auto-stash, and Delta pager

### Shell (Zsh)
- **Plugin Manager**: Uses Zinit for fast plugin loading
- **Prompt**: Starship with custom configuration
- **Aliases**: Comprehensive set of shortcuts for git, docker, kubernetes, etc.
- **Functions**: Useful shell functions for development, AWS, Docker cleanup

### Terminal & Editor
- **iTerm2**: Custom color scheme and keybindings
- **Tmux**: Vim-like keybindings and modern settings  
- **VS Code**: Full settings, keybindings, and 56 extensions (auto-installable)
- **Neovim**: Integrated with VS Code via extension

### Development Tools
- **Languages**: Python (pyenv), Node.js, Go, Java/Scala (jenv, sbt)
- **Packages**: Curated list in Brewfile (git-delta, fzf, ripgrep, bat, etc.)
- **Cloud**: AWS CLI, Podman for containers

## Managing Configurations

### Add New Tools
1. Create a new directory (e.g., `newtool/`)
2. Structure it to match your home directory: `newtool/.config/newtool/config`
3. Install with: `stow newtool`

### Update Everything
```bash
./scripts/update.sh                 # Updates packages and plugins
cd vscode && code --list-extensions > extensions.txt  # Update VS Code extensions list
```

### Backup Before Changes
```bash
./scripts/backup.sh     # Creates timestamped backup
```

### Install VS Code Extensions
```bash
cd vscode
./install-extensions.sh  # Install all VS Code extensions
```

### Remove Configurations
```bash
stow -D git            # Remove git config
stow -D zsh vscode     # Remove multiple configs
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

### Shell Setup (Zsh)
- **Zinit Plugin Manager**: Fast, efficient zsh plugin loading
- **Starship Prompt**: Modern, informative command prompt with git status
- **Rich Aliases**: Shortcuts for git, docker, kubernetes, AWS, and more
- **Custom Functions**: AWS profile management, Docker cleanup, file operations
- **XDG Compliant**: Clean home directory with configs in ~/.config

### Terminal & Editor
- **iTerm2**: Pre-configured color scheme, keybindings, and profiles
- **Tmux**: Vim-like navigation, split panes, session management
- **VS Code**: Complete setup with 56 extensions including GitHub Copilot, Python, Scala, DBT, and more
- **Neovim Integration**: VS Code Neovim extension for vim keybindings

### Development Environment
- **Multi-Language**: Python (pyenv), Node.js, Go, Java/Scala (jenv, sbt, multiple JDKs)
- **Database Tools**: DuckDB, PostgreSQL client, DBT Power User
- **Modern CLI Tools**: bat (cat), eza (ls), ripgrep (grep), fzf (fuzzy finder), fd (find)
- **Cloud & Containers**: AWS CLI, Podman, Kubernetes tools
- **Productivity**: Git Graph, GitHub Actions, Peacock, Harpoon

## Applications Included

The Brewfile installs these applications:
- **VS Code** - Code editor with extensions
- **Docker** - Container platform
- **Postman** - API testing
- **Google Chrome** - Web browser
- **Rectangle** - Window management
- **MonitorControl** - External monitor brightness control
- **Maccy** - Clipboard manager
- **Shortcat** - Keyboard-driven UI navigation

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
