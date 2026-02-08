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

# AWS Profile Management Functions

# Fuzzy command search - search history by partial command
fzf-command-search() {
    if ! command -v fzf >/dev/null 2>&1; then
        echo "fzf not installed"
        return 1
    fi
    
    # Search through history for commands containing the search term
    local query="$1"
    local selected_cmd
    
    if [ -n "$query" ]; then
        # If query provided, pre-filter history
        selected_cmd=$(history 1 | awk '{$1=""; print substr($0,2)}' | grep -i "$query" | fzf --query="$query" --height=40% --reverse)
    else
        # No query, show all history
        selected_cmd=$(history 1 | awk '{$1=""; print substr($0,2)}' | fzf --height=40% --reverse)
    fi
    
    if [ -n "$selected_cmd" ]; then
        # Put the command on the command line for editing
        print -z "$selected_cmd"
    fi
}

# Quick alias for fuzzy command search
alias fcs='fzf-command-search'

# Fuzzy find and execute from history
fzf-history-execute() {
    if ! command -v fzf >/dev/null 2>&1; then
        echo "fzf not installed"
        return 1
    fi
    
    local selected_cmd
    selected_cmd=$(history 1 | awk '{$1=""; print substr($0,2)}' | fzf --height=40% --reverse)
    
    if [ -n "$selected_cmd" ]; then
        echo "Executing: $selected_cmd"
        eval "$selected_cmd"
    fi
}

# List all available AWS profiles
aws-list-profiles() {
    echo "Available AWS profiles:"
    aws configure list-profiles
}

aws-list-regions() {
    echo "Available AWS regions:"
    aws ec2 describe-regions --output table
}

# Show current AWS profile
aws-current-profile() {
    echo "Current AWS Profile: ${AWS_PROFILE:-default}"
}

# Set AWS profile
aws-set-profile() {
    if [ -z "$1" ]; then
        echo "Usage: aws-set-profile <profile-name>"
        echo "Use 'aws-list-profiles' to see available profiles"
        return 1
    fi
    
    export AWS_PROFILE="$1"
    echo "AWS Profile set to: $AWS_PROFILE"
}

# Interactive AWS profile selection using fzf
aws-select-profile() {
    if ! command -v fzf >/dev/null 2>&1; then
        echo "Error: fzf not installed. Use 'aws-set-profile' instead."
        return 1
    fi
    
    local profile
    profile=$(aws configure list-profiles | fzf --prompt="Select AWS Profile: " --height=10)
    
    if [ -n "$profile" ]; then
        export AWS_PROFILE="$profile"
        echo "AWS Profile set to: $AWS_PROFILE"
    fi
}

# Show current AWS identity (who am I?)
aws-show-identity() {
    echo "Current AWS Profile: ${AWS_PROFILE:-default}"
    echo "AWS Identity:"
    aws sts get-caller-identity --output table 2>/dev/null || echo "Failed to get AWS identity. Check your credentials."
}

# Clear AWS profile (revert to default)
aws-clear-profile() {
    unset AWS_PROFILE
    echo "AWS Profile cleared. Using default profile."
}

# Show current AWS region
aws-current-region() {
    echo "Current AWS Region: $(aws configure get region)"
}

# Set AWS region
aws-set-region() {
    if [ -z "$1" ]; then
        echo "Usage: aws-set-region <region>"
        echo "Current region: $(aws configure get region)"
        echo "Common regions: us-east-1, us-west-2, eu-west-1, eu-central-1, ap-southeast-1"
        return 1
    fi
    
    aws configure set region "$1"
    echo "AWS Region set to: $1"
}

# Consul 
function dev-consul() {
	export CONSUL_HTTP_ADDR="https://consul.tec.dmn.we1.nexus.newday.co.uk"
	export DEPLOY_CONSUL_URL="http://consul.tec.dmn.we1.nexus.newday.co.uk"
}

function pro-consul() {
	export CONSUL_HTTP_ADDR="https://consul.tec.pmn.we1.nexus.newday.co.uk"
	export DEPLOY_CONSUL_URL="http://consul.tec.pmn.we1.nexus.newday.co.uk"
}

# Docker Cleanup Functions

# Remove all stopped containers
docker-cleanup-containers() {
    echo "Removing all stopped containers..."
    local stopped_containers=$(docker ps -aq --filter status=exited)
    if [ -n "$stopped_containers" ]; then
        docker rm $stopped_containers
        echo "✅ Removed stopped containers"
    else
        echo "ℹ️  No stopped containers to remove"
    fi
}

# Remove dangling images (untagged)
docker-cleanup-dangling() {
    echo "Removing dangling images..."
    local dangling_images=$(docker images -f "dangling=true" -q)
    if [ -n "$dangling_images" ]; then
        docker rmi $dangling_images
        echo "✅ Removed dangling images"
    else
        echo "ℹ️  No dangling images to remove"
    fi
}

# Remove unused images (not used by any container)
docker-cleanup-unused-images() {
    echo "Removing unused images..."
    docker image prune -f
    echo "✅ Removed unused images"
}

# Remove unused volumes
docker-cleanup-volumes() {
    echo "Removing unused volumes..."
    docker volume prune -f
    echo "✅ Removed unused volumes"
}

# Remove unused networks
docker-cleanup-networks() {
    echo "Removing unused networks..."
    docker network prune -f
    echo "✅ Removed unused networks"
}

# Remove build cache
docker-cleanup-cache() {
    echo "Removing build cache..."
    docker builder prune -f
    echo "✅ Removed build cache"
}

# Complete system cleanup (everything)
docker-cleanup-all() {
    echo "🧹 Starting complete Docker cleanup..."
    echo "⚠️  This will remove:"
    echo "   - All stopped containers"
    echo "   - All dangling images"
    echo "   - All unused images"
    echo "   - All unused volumes"
    echo "   - All unused networks"
    echo "   - All build cache"
    echo ""
    
    read "confirm?Are you sure you want to continue? (y/N): "
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker system prune -af --volumes
        echo "✅ Complete Docker cleanup finished!"
        docker-show-space
    else
        echo "❌ Cleanup cancelled"
    fi
}

# Show Docker disk usage
docker-show-space() {
    echo ""
    echo "📊 Docker disk usage:"
    docker system df
}

# Interactive cleanup menu
docker-cleanup-menu() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "❌ Docker not found. Please install Docker first."
        return 1
    fi
    
    echo "🐳 Docker Cleanup Menu"
    echo "======================"
    echo "1) Remove stopped containers"
    echo "2) Remove dangling images"
    echo "3) Remove unused images"
    echo "4) Remove unused volumes"
    echo "5) Remove unused networks"
    echo "6) Remove build cache"
    echo "7) Complete cleanup (ALL)"
    echo "8) Show disk usage"
    echo "9) Exit"
    echo ""
    
    read "choice?Select option (1-9): "
    
    case $choice in
        1) docker-cleanup-containers ;;
        2) docker-cleanup-dangling ;;
        3) docker-cleanup-unused-images ;;
        4) docker-cleanup-volumes ;;
        5) docker-cleanup-networks ;;
        6) docker-cleanup-cache ;;
        7) docker-cleanup-all ;;
        8) docker-show-space ;;
        9) echo "👋 Goodbye!" ;;
        *) echo "❌ Invalid option. Please select 1-9." ;;
    esac
}

# Stop and remove all containers (nuclear option)
docker-nuke-containers() {
    echo "🚨 Stopping and removing ALL containers..."
    read "confirm?This will stop and remove ALL Docker containers. Continue? (y/N): "
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker stop $(docker ps -aq) 2>/dev/null
        docker rm $(docker ps -aq) 2>/dev/null
        echo "✅ All containers stopped and removed"
    else
        echo "❌ Operation cancelled"
    fi
}

# Remove all images (nuclear option)
docker-nuke-images() {
    echo "🚨 Removing ALL Docker images..."
    read "confirm?This will remove ALL Docker images. Continue? (y/N): "
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker rmi $(docker images -q) -f 2>/dev/null
        echo "✅ All images removed"
    else
        echo "❌ Operation cancelled"
    fi
}

# Show runninM containers with resource usage
docker-ps-detailed() {
    echo "📋 Running containers with resource usage:"
    docker stats --no-stream
}