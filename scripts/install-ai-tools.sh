#!/bin/bash
# Install AI-optimized CLI tools based on 2025 research
# =====================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Installing AI-Optimized CLI Tools ===${NC}"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    INSTALL_CMD="brew install"
    echo "Detected macOS, using Homebrew"
else
    if command -v apt-get &> /dev/null; then
        INSTALL_CMD="sudo apt-get install -y"
        echo "Detected Debian/Ubuntu"
    else
        echo -e "${RED}Unsupported OS${NC}"
        exit 1
    fi
fi

# Function to install tool
install_tool() {
    local tool=$1
    local brew_name=$2
    local apt_name=$3
    
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}✓ $tool already installed${NC}"
    else
        echo -e "${YELLOW}Installing $tool...${NC}"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            $INSTALL_CMD $brew_name
        else
            $INSTALL_CMD $apt_name
        fi
    fi
}

# Core tools for AI workflows
echo -e "\n${YELLOW}Installing core AI-friendly tools...${NC}"

# Ripgrep - 5-10x faster than grep, clean output
install_tool "rg" "ripgrep" "ripgrep"

# fd - 3-5x faster than find, intuitive syntax
install_tool "fd" "fd" "fd-find"

# bat - better cat with syntax highlighting
install_tool "bat" "bat" "bat"

# eza - modern ls replacement
install_tool "eza" "eza" "eza"

# jq - JSON processor
install_tool "jq" "jq" "jq"

# yq - YAML processor
install_tool "yq" "yq" "yq"

# delta - better git diff
install_tool "delta" "git-delta" "git-delta"

# lazygit - terminal UI for git
install_tool "lazygit" "lazygit" "lazygit"

# httpie - better curl
install_tool "http" "httpie" "httpie"

# tldr - simplified man pages
install_tool "tldr" "tldr" "tldr"

# Terminal performance tools
echo -e "\n${YELLOW}Installing performance monitoring tools...${NC}"

# btop - better top
install_tool "btop" "btop" "btop"

# ncdu - disk usage analyzer
install_tool "ncdu" "ncdu" "ncdu"

# macOS specific tools
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n${YELLOW}Installing macOS specific tools...${NC}"
    
    # Terminal emulators
    if ! ls /Applications/Alacritty.app &> /dev/null; then
        echo "Installing Alacritty (fast terminal)..."
        brew install --cask alacritty
    fi
fi

# Install Node.js tools via npm
if command -v npm &> /dev/null; then
    echo -e "\n${YELLOW}Installing npm-based tools...${NC}"
    
    # MCP Inspector for debugging
    if ! command -v npx &> /dev/null || ! npx @modelcontextprotocol/inspector --version &> /dev/null 2>&1; then
        echo "Installing MCP Inspector..."
        npm install -g @modelcontextprotocol/inspector
    fi
fi

# Python tools
if command -v pip3 &> /dev/null; then
    echo -e "\n${YELLOW}Installing Python-based tools...${NC}"
    
    # uv for Python package management
    if ! command -v uv &> /dev/null; then
        echo "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
fi

echo -e "\n${GREEN}=== Installation Summary ===${NC}"
echo "Essential tools:"
command -v rg &> /dev/null && echo -e "${GREEN}✓ ripgrep${NC}" || echo -e "${RED}✗ ripgrep${NC}"
command -v fd &> /dev/null && echo -e "${GREEN}✓ fd${NC}" || echo -e "${RED}✗ fd${NC}"
command -v bat &> /dev/null && echo -e "${GREEN}✓ bat${NC}" || echo -e "${RED}✗ bat${NC}"
command -v eza &> /dev/null && echo -e "${GREEN}✓ eza${NC}" || echo -e "${RED}✗ eza${NC}"
command -v jq &> /dev/null && echo -e "${GREEN}✓ jq${NC}" || echo -e "${RED}✗ jq${NC}"

echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Source your .zshrc: source ~/.zshrc"
echo "2. Test MCP servers: claude mcp list"
echo "3. Initialize a project: claude-init"
echo "4. Check debug tools: mcpdebug"