# VS Code Configuration

This directory contains VS Code settings, keybindings, and extensions.

## Files

- `extensions.txt` - List of installed extensions
- `install-extensions.sh` - Script to install all extensions
- `.config/Code/User/settings.json` - VS Code settings
- `.config/Code/User/keybindings.json` - Custom keybindings

## Setup on New Machine

### 1. Install VS Code
Download from [code.visualstudio.com](https://code.visualstudio.com/)

### 2. Install 'code' command in PATH
Open VS Code → Command Palette (Cmd+Shift+P) → "Shell Command: Install 'code' command in PATH"

### 3. Link settings and keybindings
```bash
cd ~/dotfiles
stow vscode
```

This will symlink:
- `settings.json` → `~/Library/Application Support/Code/User/settings.json`
- `keybindings.json` → `~/Library/Application Support/Code/User/keybindings.json`

### 4. Install extensions
```bash
cd ~/dotfiles/vscode
./install-extensions.sh
```

This will install all extensions from `extensions.txt`.

### 5. Restart VS Code
Close and reopen VS Code to load all extensions.

## Updating Extensions List

When you install new extensions, update the list:
```bash
cd ~/dotfiles/vscode
code --list-extensions > extensions.txt
```

## Notes

- Settings include your personal preferences, themes, and extension configurations
- Some extensions may require additional setup (API keys, sign-in, etc.)
- The Neovim extension requires Neovim to be installed (automatically installed via Brewfile)
