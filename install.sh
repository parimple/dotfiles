#!/bin/bash
# Quick Dotfiles Installer
# Usage: curl -sL https://raw.githubusercontent.com/USER/dotfiles/main/install.sh | bash

set -e

DOTFILES_REPO="https://github.com/parimple/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Dotfiles Installer ===${NC}"

# Clone repository
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${YELLOW}Cloning dotfiles...${NC}"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo -e "${YELLOW}Updating dotfiles...${NC}"
    cd "$DOTFILES_DIR" && git pull
fi

# Run sync script
cd "$DOTFILES_DIR"
bash sync.sh --local

echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${YELLOW}Restart your shell or run: source ~/.zshrc${NC}"