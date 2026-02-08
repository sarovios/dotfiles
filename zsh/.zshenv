# ~/.zshenv
# Environment variables loaded for all zsh sessions

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Move zsh config to XDG_CONFIG_HOME
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Homebrew setup (for Apple Silicon Macs)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Ensure Homebrew Git takes precedence over system Git
    export PATH="/opt/homebrew/opt/git/bin:$PATH"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
    # Ensure Homebrew Git takes precedence over system Git
    export PATH="/usr/local/opt/git/bin:$PATH"
fi

# Default applications
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# PATH modifications
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/opt/homebrew/Cellar/bin:$PATH"

# Python (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Java (jenv)
export JENV_ROOT="$HOME/.jenv"
export PATH="$JENV_ROOT/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# SSL Certificates (Company-specific - uncomment and configure if needed)
# Useful for corporate proxies/firewalls - adjust path to your certificate location
# if [[ -f "$HOME/.certs/combined-ca-bundle.pem" ]]; then
#     export SSL_CERT_FILE="$HOME/.certs/combined-ca-bundle.pem"
#     export REQUESTS_CA_BUNDLE="$HOME/.certs/combined-ca-bundle.pem"
#     export CURL_CA_BUNDLE="$HOME/.certs/combined-ca-bundle.pem"
# fi

# Company-specific environment variables (uncomment and adjust as needed)
# export DBT_SNOWFLAKE_AD_USER_ID=YOUR_USER_ID
# export DBT_ENV=local_dev
