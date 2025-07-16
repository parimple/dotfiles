#!/bin/bash
# MCP Configuration Sync
# Syncs MCP servers configuration across machines

MCP_CONFIG_DIR="$HOME/Library/Application Support/Claude"
DOTFILES_MCP="$HOME/dotfiles/mcp"
MCP_SERVERS_DIR="$HOME/mcp-servers"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== MCP Sync ===${NC}"

# Function to update MCP server paths
update_mcp_paths() {
    local config_file="$1"
    local home_path="$HOME"
    
    # Use jq to update paths dynamically
    if command -v jq &> /dev/null; then
        # Update paths in config to use current $HOME
        jq --arg home "$home_path" '
            .mcpServers |= map_values(
                if .args then
                    .args |= map(gsub("/Users/[^/]+"; $home))
                else . end
            )
        ' "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        echo -e "${GREEN}✓ Updated MCP paths for current user${NC}"
    else
        echo -e "${YELLOW}Warning: jq not installed. Install with: brew install jq${NC}"
    fi
}

# 1. Sync MCP config
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}[macOS] Syncing MCP configuration${NC}"
    
    # Backup current config
    if [ -f "$MCP_CONFIG_DIR/claude_desktop_config.json" ]; then
        cp "$MCP_CONFIG_DIR/claude_desktop_config.json" "$MCP_CONFIG_DIR/claude_desktop_config.backup.json"
    fi
    
    # Copy from dotfiles
    if [ -f "$DOTFILES_MCP/claude_desktop_config.json" ]; then
        cp "$DOTFILES_MCP/claude_desktop_config.json" "$MCP_CONFIG_DIR/claude_desktop_config.json"
        update_mcp_paths "$MCP_CONFIG_DIR/claude_desktop_config.json"
        echo -e "${GREEN}✓ MCP config synced${NC}"
    fi
fi

# 2. Sync MCP servers code
if [ -d "$DOTFILES_MCP/servers" ]; then
    echo -e "${YELLOW}Syncing MCP servers...${NC}"
    mkdir -p "$MCP_SERVERS_DIR"
    rsync -av --exclude='.git' "$DOTFILES_MCP/servers/" "$MCP_SERVERS_DIR/"
    echo -e "${GREEN}✓ MCP servers synced${NC}"
fi

# 3. Build MCP servers if needed
if [ -d "$MCP_SERVERS_DIR/mcp-official-servers" ]; then
    echo -e "${YELLOW}Building MCP servers...${NC}"
    cd "$MCP_SERVERS_DIR/mcp-official-servers"
    
    for server in filesystem git memory fetch sequentialthinking; do
        if [ -d "src/$server" ]; then
            echo -e "Building $server..."
            (cd "src/$server" && npm install && npm run build) &> /dev/null && \
                echo -e "${GREEN}✓ $server built${NC}" || \
                echo -e "${RED}✗ $server build failed${NC}"
        fi
    done
fi

echo -e "${GREEN}✓ MCP sync complete!${NC}"
echo -e "${YELLOW}Restart Claude Desktop to apply changes${NC}"