#!/bin/bash
# Dotfiles Sync Script
# Synchronizes configurations across all machines

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to sync files
sync_file() {
    local source=$1
    local target=$2
    local name=$3
    
    if [ -f "$target" ]; then
        # Backup existing file
        cp "$target" "$BACKUP_DIR/" 2>/dev/null
        echo -e "${YELLOW}Backed up existing $name${NC}"
    fi
    
    # Create directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓ Synced $name${NC}"
}

# Function to sync to remote
sync_remote() {
    local host=$1
    echo -e "\n${GREEN}Syncing to $host...${NC}"
    
    # Copy dotfiles directory
    rsync -avz --exclude='.git' --exclude='*.swp' "$DOTFILES_DIR/" "$host:~/dotfiles/"
    
    # Run sync script on remote
    ssh "$host" "cd ~/dotfiles && bash sync.sh --local"
}

# Parse arguments
if [[ "$1" == "--local" ]]; then
    LOCAL_ONLY=true
else
    LOCAL_ONLY=false
fi

echo -e "${GREEN}=== Dotfiles Sync ===${NC}"

# 1. Sync ZSH
echo -e "\n${YELLOW}[ZSH Configuration]${NC}"
sync_file "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc" "zshrc"
sync_file "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile" "zprofile" 2>/dev/null || true
sync_file "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv" "zshenv" 2>/dev/null || true

# 2. Sync TMUX
echo -e "\n${YELLOW}[TMUX Configuration]${NC}"
sync_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf" "tmux.conf"

# 3. Sync MCP (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n${YELLOW}[MCP Configuration]${NC}"
    MCP_DIR="$HOME/Library/Application Support/Claude"
    if [ -f "$DOTFILES_DIR/mcp/claude_desktop_config.json" ]; then
        sync_file "$DOTFILES_DIR/mcp/claude_desktop_config.json" "$MCP_DIR/claude_desktop_config.json" "Claude MCP config"
    fi
fi

# 4. Sync scripts
echo -e "\n${YELLOW}[Scripts]${NC}"
mkdir -p "$HOME/bin"
for script in "$DOTFILES_DIR/scripts"/*; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        sync_file "$script" "$HOME/bin/$script_name" "$script_name"
        chmod +x "$HOME/bin/$script_name"
    fi
done

# 5. Source configurations
echo -e "\n${YELLOW}[Reloading configurations]${NC}"
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc" 2>/dev/null || echo "Note: Run 'source ~/.zshrc' to reload ZSH"
fi

# 6. Sync to remote hosts (if not local-only)
if [ "$LOCAL_ONLY" = false ]; then
    echo -e "\n${YELLOW}[Remote Sync]${NC}"
    
    # Define remote hosts
    REMOTE_HOSTS=("oracle" "evertz")
    
    for host in "${REMOTE_HOSTS[@]}"; do
        read -p "Sync to $host? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sync_remote "$host" || echo -e "${RED}Failed to sync to $host${NC}"
        fi
    done
fi

echo -e "\n${GREEN}✓ Sync complete!${NC}"
echo -e "${YELLOW}Backup saved to: $BACKUP_DIR${NC}"

# Git commit changes
if [ "$LOCAL_ONLY" = false ]; then
    cd "$DOTFILES_DIR"
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "\n${YELLOW}[Git]${NC}"
        git add -A
        git commit -m "Auto-sync: $(date +%Y-%m-%d\ %H:%M:%S)" || true
        echo -e "${GREEN}✓ Changes committed${NC}"
    fi
fi