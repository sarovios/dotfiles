# ~/.config/zsh/aliases.zsh
# Command aliases

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"

# List files/directories
if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias ll="eza -l"
    alias la="eza -la"
    alias lt="eza --tree"
else
    alias ll="ls -l"
    alias la="ls -la"
fi

# File operations
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias mkdir="mkdir -p"

# Git (only essential shell-level aliases)
alias g="git"

# Docker
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias di="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
alias dstop="docker stop"
alias dstart="docker start"

# Kubernetes
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdd="kubectl describe deployment"

# Network
alias ping="ping -c 5"
alias myip="curl -4 ifconfig.co"
alias localip="ipconfig getifaddr en0"

# System
alias top="htop"
alias df="df -h"
alias du="du -h"
alias free="vm_stat"

# Text processing
if command -v bat >/dev/null 2>&1; then
    alias cat="bat"
fi

# Python
alias py="python3"
alias pip="pip3"
alias venv="python3 -m venv"
alias activate="source venv/bin/activate"

# Node.js
alias ni="npm install"
alias ns="npm start"
alias nt="npm test"
alias nb="npm run build"

# Quick edits
alias zshrc="$EDITOR ~/.config/zsh/.zshrc"
alias vimrc="$EDITOR ~/.config/nvim/init.vim"
alias aliases="$EDITOR ~/.config/zsh/aliases.zsh"

# Reload shell
alias reload="source ~/.config/zsh/.zshrc"

# Clear screen
alias c="clear"

# History
alias h="history"

# Make executable
alias x+="chmod +x"

# Weather
alias weather="curl wttr.in"

# Homebrew
alias bi="brew install"
alias bs="brew search"
alias bu="brew update && brew upgrade"
alias bc="brew cleanup"

