#!/bin/bash
# MCP Debug Tools for Claude Code (Subscription Version)
# =====================================================

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# MCP log location (macOS)
MCP_LOG_DIR="$HOME/Library/Logs/Claude"
MCP_CONFIG_DIR="$HOME/.claude"

# Function: Show MCP status
mcp_status() {
    echo -e "${GREEN}=== MCP Server Status ===${NC}"
    
    # Check if Claude Code is installed
    if command -v claude &> /dev/null; then
        echo -e "${GREEN}✓ Claude Code installed${NC}"
        echo "  Version: $(claude --version 2>/dev/null || echo 'unknown')"
    else
        echo -e "${RED}✗ Claude Code not found${NC}"
        return 1
    fi
    
    # List MCP servers
    echo -e "\n${YELLOW}Configured MCP Servers:${NC}"
    claude mcp list 2>/dev/null || echo "  No servers configured"
    
    # Check for running MCP processes
    echo -e "\n${YELLOW}Running MCP Processes:${NC}"
    ps aux | grep -E "(mcp-server|modelcontextprotocol)" | grep -v grep | head -5 || echo "  No MCP processes found"
}

# Function: Tail MCP logs
mcp_logs() {
    local lines=${1:-50}
    echo -e "${GREEN}=== Recent MCP Logs (last $lines lines) ===${NC}"
    
    if [ -d "$MCP_LOG_DIR" ]; then
        # Find most recent log file
        latest_log=$(ls -t "$MCP_LOG_DIR"/*.log 2>/dev/null | head -1)
        if [ -n "$latest_log" ]; then
            echo "Log file: $latest_log"
            tail -n "$lines" "$latest_log"
        else
            echo "No log files found in $MCP_LOG_DIR"
        fi
    else
        echo "Log directory not found: $MCP_LOG_DIR"
    fi
}

# Function: Watch MCP logs in real-time
mcp_watch() {
    echo -e "${GREEN}=== Watching MCP Logs ===${NC}"
    echo "Press Ctrl+C to stop"
    
    if [ -d "$MCP_LOG_DIR" ]; then
        tail -f "$MCP_LOG_DIR"/*.log 2>/dev/null || echo "No logs to watch"
    else
        echo "Log directory not found: $MCP_LOG_DIR"
    fi
}

# Function: Test MCP server
mcp_test() {
    local server=$1
    
    if [ -z "$server" ]; then
        echo "Usage: mcp_test <server-name>"
        echo "Available servers:"
        claude mcp list 2>/dev/null | awk '{print "  - " $1}' | sed 's/:$//'
        return 1
    fi
    
    echo -e "${GREEN}=== Testing MCP Server: $server ===${NC}"
    
    # Try to get server info
    local server_info=$(claude mcp list | grep "^$server:")
    if [ -z "$server_info" ]; then
        echo -e "${RED}Server '$server' not found${NC}"
        return 1
    fi
    
    echo "Server configuration: $server_info"
    
    # Test with MCP inspector if available
    if command -v npx &> /dev/null; then
        echo -e "\n${YELLOW}Starting MCP Inspector...${NC}"
        echo "This will open an interactive debugging session."
        echo "Press Ctrl+C to exit."
        
        # Extract command from server info
        local cmd=$(echo "$server_info" | cut -d' ' -f2-)
        npx @modelcontextprotocol/inspector $cmd
    else
        echo -e "${RED}npx not found. Install Node.js to use MCP Inspector${NC}"
    fi
}

# Function: Clear MCP logs
mcp_clear_logs() {
    echo -e "${YELLOW}Clear MCP logs?${NC}"
    read -p "This will delete all Claude logs. Continue? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -d "$MCP_LOG_DIR" ]; then
            rm -f "$MCP_LOG_DIR"/*.log
            echo -e "${GREEN}✓ Logs cleared${NC}"
        else
            echo "Log directory not found"
        fi
    else
        echo "Cancelled"
    fi
}

# Function: Debug MCP server errors
mcp_debug_errors() {
    echo -e "${GREEN}=== Recent MCP Errors ===${NC}"
    
    if [ -d "$MCP_LOG_DIR" ]; then
        echo -e "\n${YELLOW}Error messages from logs:${NC}"
        grep -i -E "(error|fail|exception|fatal)" "$MCP_LOG_DIR"/*.log 2>/dev/null | tail -20 || echo "No errors found"
        
        echo -e "\n${YELLOW}Warning messages:${NC}"
        grep -i "warn" "$MCP_LOG_DIR"/*.log 2>/dev/null | tail -10 || echo "No warnings found"
    else
        echo "Log directory not found: $MCP_LOG_DIR"
    fi
}

# Function: Show MCP config
mcp_config() {
    echo -e "${GREEN}=== MCP Configuration ===${NC}"
    
    # Check local config
    if [ -f "$MCP_CONFIG_DIR/mcp.json" ]; then
        echo -e "\n${YELLOW}Local config ($MCP_CONFIG_DIR/mcp.json):${NC}"
        jq . "$MCP_CONFIG_DIR/mcp.json" 2>/dev/null || cat "$MCP_CONFIG_DIR/mcp.json"
    fi
    
    # Check project config
    if [ -f ".claude/mcp.json" ]; then
        echo -e "\n${YELLOW}Project config (.claude/mcp.json):${NC}"
        jq . ".claude/mcp.json" 2>/dev/null || cat ".claude/mcp.json"
    fi
    
    # Check VS Code config
    if [ -f ".vscode/mcp.json" ]; then
        echo -e "\n${YELLOW}VS Code config (.vscode/mcp.json):${NC}"
        jq . ".vscode/mcp.json" 2>/dev/null || cat ".vscode/mcp.json"
    fi
}

# Main menu
show_menu() {
    echo -e "${GREEN}=== MCP Debug Tools ===${NC}"
    echo "1) Show MCP status"
    echo "2) View recent logs"
    echo "3) Watch logs (real-time)"
    echo "4) Test MCP server"
    echo "5) Show recent errors"
    echo "6) Show configuration"
    echo "7) Clear logs"
    echo "q) Quit"
    echo
    read -p "Select option: " choice
    
    case $choice in
        1) mcp_status ;;
        2) mcp_logs ;;
        3) mcp_watch ;;
        4) 
            read -p "Server name: " server
            mcp_test "$server"
            ;;
        5) mcp_debug_errors ;;
        6) mcp_config ;;
        7) mcp_clear_logs ;;
        q) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
    
    echo
    read -p "Press Enter to continue..."
    clear
    show_menu
}

# Handle command line arguments
case "${1:-menu}" in
    status) mcp_status ;;
    logs) mcp_logs "${2:-50}" ;;
    watch) mcp_watch ;;
    test) mcp_test "$2" ;;
    errors) mcp_debug_errors ;;
    config) mcp_config ;;
    clear) mcp_clear_logs ;;
    menu|*) show_menu ;;
esac