# ~/.config/zsh/.zshrc
# Main zsh configuration file

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
if command -v fzf >/dev/null 2>&1; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
fi

# Aliases
source ~/.config/zsh/aliases.zsh

# Functions
source ~/.config/zsh/functions.zsh

# Shell integrations
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
else
    echo "Warning: fzf not found. Install with 'brew install fzf' for enhanced file/history search."
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    echo "Warning: starship not found. Install with 'brew install starship' for modern prompt."
fi

# Check optional dependencies
if ! command -v eza >/dev/null 2>&1; then
    echo "Info: eza not found. Install with 'brew install eza' for enhanced ls output."
fi

if ! command -v bat >/dev/null 2>&1; then
    echo "Info: bat not found. Install with 'brew install bat' for enhanced cat with syntax highlighting."
fi

if ! command -v rg >/dev/null 2>&1; then
    echo "Info: rg (ripgrep) not found. Install with 'brew install ripgrep' for fast text search."
fi

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"

# Homebrew setup (for Apple Silicon Macs)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Node.js
export PATH="$HOME/.npm-global/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
