#!/bin/bash

# Install VS Code extensions from extensions.txt
# Run this after installing VS Code on a new machine

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

if [ ! -f "$EXTENSIONS_FILE" ]; then
    echo "Error: extensions.txt not found in $SCRIPT_DIR"
    exit 1
fi

if ! command -v code &> /dev/null; then
    echo "Error: VS Code 'code' command not found in PATH"
    echo "Make sure VS Code is installed and the 'code' command is available"
    echo "You can add it via: Command Palette > Shell Command: Install 'code' command in PATH"
    exit 1
fi

echo "Installing VS Code extensions..."
echo ""

while IFS= read -r extension; do
    # Skip empty lines and comments
    [[ -z "$extension" || "$extension" =~ ^# ]] && continue
    
    echo "Installing: $extension"
    code --install-extension "$extension" --force
done < "$EXTENSIONS_FILE"

echo ""
echo "✅ All extensions installed!"
echo ""
echo "Note: Some extensions may require VS Code to be restarted."
