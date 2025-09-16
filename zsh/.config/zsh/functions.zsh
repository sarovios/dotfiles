# ~/.config/zsh/functions.zsh
# Custom shell functions

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find files by name
ff() {
    find . -type f -name "*$1*"
}

# Find directories by name
fd() {
    find . -type d -name "*$1*"
}

# Search in files using ripgrep or grep
search() {
    if command -v rg >/dev/null 2>&1; then
        rg "$1"
    else
        grep -r "$1" .
    fi
}

# Get current git branch
git_current_branch() {
    git branch --show-current 2>/dev/null
}

# Switch to git branch with fzf
git_branch_fzf() {
    if command -v fzf >/dev/null 2>&1; then
        local branch=$(git branch | fzf | sed 's/^[* ]*//')
        if [ -n "$branch" ]; then
            git checkout "$branch"
        fi
    else
        echo "fzf not installed"
    fi
}

# Show file size in human readable format
sizeof() {
    if [ -f "$1" ]; then
        ls -lh "$1" | awk '{print $5}'
    elif [ -d "$1" ]; then
        du -sh "$1" | awk '{print $1}'
    else
        echo "File or directory not found"
    fi
}

# Create a backup of a file
backup() {
    if [ -f "$1" ]; then
        cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backup created: $1.backup.$(date +%Y%m%d_%H%M%S)"
    else
        echo "File not found: $1"
    fi
}

# Quick server on current directory
serve() {
    local port=${1:-8000}
    echo "Starting server on http://localhost:$port"
    if command -v python3 >/dev/null 2>&1; then
        python3 -m http.server "$port"
    elif command -v python >/dev/null 2>&1; then
        python -m SimpleHTTPServer "$port"
    else
        echo "Python not found"
    fi
}

# Generate random password
genpass() {
    local length=${1:-16}
    openssl rand -base64 "$length" | tr -d "=+/" | cut -c1-$length
}

# Convert video to gif
vid2gif() {
    if [ $# -ne 2 ]; then
        echo "Usage: vid2gif input.mp4 output.gif"
        return 1
    fi
    
    if command -v ffmpeg >/dev/null 2>&1; then
        ffmpeg -i "$1" -vf "fps=10,scale=320:-1:flags=lanczos" -c:v gif "$2"
    else
        echo "ffmpeg not installed"
    fi
}
