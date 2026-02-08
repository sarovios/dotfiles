# Setup Checklist for New Machine

Use this checklist when setting up your dotfiles on a new machine.

## Pre-Installation

- [ ] Clone the dotfiles repository to `~/dotfiles`
- [ ] Review the [Brewfile](Brewfile) and uncomment/add any applications you want

## Installation

```bash
cd ~/dotfiles
./install.sh
```

## Post-Installation Configuration

### 1. Git Configuration (Required)

Edit [git/.config/git/config](git/.config/git/config):

```bash
[user]
    name = YOUR_NAME          # Change this
    email = YOUR_EMAIL        # Change this

[github]
    user = YOUR_GITHUB_USER   # Change this
```

Or use git commands:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@domain.com"
git config --global github.user "yourusername"
```

### 2. Editor Preference (Optional)

In [git/.config/git/config](git/.config/git/config), change the editor if you don't use VS Code:

```bash
[core]
    editor = nvim              # Or vim, nano, etc.
```

### 3. SSL Certificates (If Needed)

If you're behind a corporate proxy with custom certificates:

1. Place your certificate bundle at: `~/.certs/combined-ca-bundle.pem`
2. The configuration will automatically detect and use it

### 4. Company-Specific Variables (If Needed)

Edit [zsh/.zshenv](zsh/.zshenv) and uncomment/modify company-specific variables:

```bash
# DBT and Snowflake (Company-specific - uncomment and adjust as needed)
export DBT_SNOWFLAKE_AD_USER_ID=YOUR_USER_ID
export DBT_ENV=local_dev
```

### 5. SSH Keys

Generate SSH keys if you don't have them:

```bash
ssh-keygen -t ed25519 -C "your.email@domain.com"
```

Add to GitHub/GitLab:
```bash
cat ~/.ssh/id_ed25519.pub
# Copy the output and add to your Git provider
```

### 6. GitHub CLI Authentication

```bash
gh auth login
```

### 7. Review PATH Modifications

Check [zsh/.zshenv](zsh/.zshenv) and adjust PATH entries for your needs:
- JetBrains Toolbox scripts
- npm global packages
- pyenv, jenv, Go, Rust paths

### 8. Optional: Configure jenv for Java

```bash
# Add Java versions to jenv
jenv add /Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home

# Set global Java version
jenv global 11
```

## Verification

After setup, verify everything is working:

```bash
# Check shell configuration
echo $ZDOTDIR  # Should show ~/.config/zsh

# Check git configuration
git config --list | grep user

# Check Starship prompt
starship --version

# Check installed tools
brew list
```

## Restart Terminal

Close and reopen your terminal to ensure all changes take effect, or run:

```bash
source ~/.zshenv
```

## Troubleshooting

### Zsh plugins not loading

If zinit didn't install automatically, run:
```bash
source ~/.config/zsh/.zshrc
```

### Stow conflicts

If you get conflicts during stowing, backup your existing configs:
```bash
./scripts/backup.sh
```

Then remove the conflicting files and run `./install.sh` again.

### Command not found

Make sure Homebrew is in your PATH:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# or
eval "$(/usr/local/bin/brew shellenv)"     # Intel
```

## Regular Maintenance

Keep your setup updated:
```bash
# Update packages and plugins
./scripts/update.sh

# Backup current configuration
./scripts/backup.sh
```
