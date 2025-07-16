#!/bin/bash
# Enhanced Dotfiles Sync Script
# Synchronizes modern configurations across all machines

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to sync files
sync_file() {
    local source=$1
    local target=$2
    local name=$3
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        # Backup existing file
        cp -r "$target" "$BACKUP_DIR/" 2>/dev/null
        echo -e "${YELLOW}Backed up existing $name${NC}"
    fi
    
    # Create directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Remove existing symlink or file
    rm -rf "$target" 2>/dev/null
    
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
    ssh "$host" "cd ~/dotfiles && bash sync-enhanced.sh --local"
}

# Parse arguments
LOCAL_ONLY=false
USE_ENHANCED=false
for arg in "$@"; do
    case $arg in
        --local)
            LOCAL_ONLY=true
            ;;
        --enhanced)
            USE_ENHANCED=true
            ;;
    esac
done

echo -e "${BLUE}=== Enhanced Dotfiles Sync ===${NC}"

# 1. Sync ZSH
echo -e "\n${YELLOW}[ZSH Configuration]${NC}"
if [ "$USE_ENHANCED" = true ] && [ -f "$DOTFILES_DIR/zsh/zshrc-enhanced" ]; then
    sync_file "$DOTFILES_DIR/zsh/zshrc-enhanced" "$HOME/.zshrc" "zshrc (enhanced)"
else
    sync_file "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc" "zshrc"
fi

# 2. Sync TMUX
echo -e "\n${YELLOW}[TMUX Configuration]${NC}"
if [ "$USE_ENHANCED" = true ] && [ -f "$DOTFILES_DIR/tmux/tmux-enhanced.conf" ]; then
    sync_file "$DOTFILES_DIR/tmux/tmux-enhanced.conf" "$HOME/.tmux.conf" "tmux.conf (enhanced)"
else
    sync_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf" "tmux.conf"
fi

# 3. Sync Starship
if [ -f "$DOTFILES_DIR/starship/starship.toml" ]; then
    echo -e "\n${YELLOW}[Starship Configuration]${NC}"
    sync_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml" "starship.toml"
fi

# 4. Sync Git config (enhanced)
echo -e "\n${YELLOW}[Git Configuration]${NC}"
if [ -f "$DOTFILES_DIR/git/gitconfig" ]; then
    sync_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig" "gitconfig"
fi

# 5. Sync scripts
echo -e "\n${YELLOW}[Scripts]${NC}"
mkdir -p "$HOME/bin"
for script in "$DOTFILES_DIR/scripts"/*; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        sync_file "$script" "$HOME/bin/$script_name" "$script_name"
        chmod +x "$HOME/bin/$script_name"
    fi
done

# 6. Platform-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n${YELLOW}[macOS Specific]${NC}"
    
    # MCP Configuration
    MCP_DIR="$HOME/Library/Application Support/Claude"
    if [ -f "$DOTFILES_DIR/mcp/claude_desktop_config.json" ]; then
        sync_file "$DOTFILES_DIR/mcp/claude_desktop_config.json" "$MCP_DIR/claude_desktop_config.json" "Claude MCP config"
    fi
    
    # Homebrew Bundle
    if [ -f "$DOTFILES_DIR/macos/Brewfile" ]; then
        sync_file "$DOTFILES_DIR/macos/Brewfile" "$HOME/.Brewfile" "Brewfile"
    fi
fi

# 7. Create necessary directories
echo -e "\n${YELLOW}[Creating directories]${NC}"
mkdir -p "$HOME/.config"/{bat,git,lazygit}
mkdir -p "$HOME/.local/"{bin,share}
echo -e "${GREEN}✓ Created config directories${NC}"

# 8. Install tools if requested
if [ "$USE_ENHANCED" = true ]; then
    echo -e "\n${YELLOW}[Tool Installation]${NC}"
    read -p "Install modern CLI tools? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/scripts/install-modern-tools.sh"
    fi
fi

# 9. Source configurations
echo -e "\n${YELLOW}[Reloading configurations]${NC}"
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc" 2>/dev/null || echo "Note: Run 'source ~/.zshrc' to reload ZSH"
fi

# 10. Sync to remote hosts (if not local-only)
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

# Show tips
echo -e "\n${BLUE}==== Quick Tips ====${NC}"
echo -e "- Use ${GREEN}--enhanced${NC} flag to use modern configs"
echo -e "- Inside tmux, press ${GREEN}prefix + I${NC} to install plugins"
echo -e "- Run ${GREEN}tldr --update${NC} to update TLDR pages"
echo -e "- Try ${GREEN}fzf${NC} shortcuts: Ctrl+R (history), Ctrl+T (files)"
echo -e "- Use ${GREEN}z${NC} instead of cd for smart navigation"