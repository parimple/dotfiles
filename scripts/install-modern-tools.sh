#!/bin/bash
# Install Modern CLI Tools - Reddit Community Favorites
# =====================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}Installing Modern CLI Tools - Reddit Favorites${NC}"
echo -e "${BLUE}=================================================${NC}"

# Detect OS
OS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/debian_version ]; then
        OS="debian"
    elif [ -f /etc/redhat-release ]; then
        OS="redhat"
    elif [ -f /etc/arch-release ]; then
        OS="arch"
    fi
fi

echo -e "${YELLOW}Detected OS: $OS${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install with appropriate package manager
install_package() {
    local package=$1
    local brew_package=${2:-$1}
    local apt_package=${3:-$1}
    
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            brew install "$brew_package"
        else
            echo -e "${RED}Homebrew not installed. Please install it first.${NC}"
            exit 1
        fi
    elif [[ "$OS" == "debian" ]]; then
        sudo apt-get update && sudo apt-get install -y "$apt_package"
    elif [[ "$OS" == "arch" ]]; then
        sudo pacman -S --noconfirm "$package"
    else
        echo -e "${RED}Unsupported OS for automatic installation${NC}"
        return 1
    fi
}

# =====================================================
# CORE TOOLS (Most upvoted on Reddit)
# =====================================================

echo -e "\n${YELLOW}Installing Core Tools...${NC}"

# Starship - The minimal, blazing-fast, and infinitely customizable prompt
if ! command_exists starship; then
    echo -e "${GREEN}Installing Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo -e "${BLUE}Starship already installed${NC}"
fi

# FZF - Fuzzy finder (Reddit's #1 productivity tool)
if ! command_exists fzf; then
    echo -e "${GREEN}Installing FZF...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install fzf
        $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
    fi
else
    echo -e "${BLUE}FZF already installed${NC}"
fi

# Eza - Modern replacement for ls
if ! command_exists eza; then
    echo -e "${GREEN}Installing Eza...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install eza
    elif [[ "$OS" == "debian" ]]; then
        sudo apt update
        sudo apt install -y gpg
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
    else
        cargo install eza
    fi
else
    echo -e "${BLUE}Eza already installed${NC}"
fi

# Bat - Cat with syntax highlighting
if ! command_exists bat; then
    echo -e "${GREEN}Installing Bat...${NC}"
    install_package bat bat bat
else
    echo -e "${BLUE}Bat already installed${NC}"
fi

# Ripgrep - Faster grep
if ! command_exists rg; then
    echo -e "${GREEN}Installing Ripgrep...${NC}"
    install_package ripgrep ripgrep ripgrep
else
    echo -e "${BLUE}Ripgrep already installed${NC}"
fi

# fd - Faster find
if ! command_exists fd; then
    echo -e "${GREEN}Installing fd...${NC}"
    install_package fd fd fd-find
    # Create symlink on Debian
    if [[ "$OS" == "debian" ]] && ! command_exists fd; then
        sudo ln -s $(which fdfind) /usr/local/bin/fd
    fi
else
    echo -e "${BLUE}fd already installed${NC}"
fi

# Zoxide - Smarter cd
if ! command_exists zoxide; then
    echo -e "${GREEN}Installing Zoxide...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install zoxide
    else
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
else
    echo -e "${BLUE}Zoxide already installed${NC}"
fi

# Delta - Better git diffs
if ! command_exists delta; then
    echo -e "${GREEN}Installing Delta...${NC}"
    install_package git-delta git-delta git-delta
else
    echo -e "${BLUE}Delta already installed${NC}"
fi

# Lazygit - Terminal UI for git
if ! command_exists lazygit; then
    echo -e "${GREEN}Installing Lazygit...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install lazygit
    else
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_$(uname -s)_$(uname -m).tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
    fi
else
    echo -e "${BLUE}Lazygit already installed${NC}"
fi

# Btop - System monitor
if ! command_exists btop; then
    echo -e "${GREEN}Installing Btop...${NC}"
    install_package btop btop btop
else
    echo -e "${BLUE}Btop already installed${NC}"
fi

# TLDR - Community-driven man pages
if ! command_exists tldr; then
    echo -e "${GREEN}Installing TLDR...${NC}"
    install_package tldr tldr tldr
else
    echo -e "${BLUE}TLDR already installed${NC}"
fi

# =====================================================
# ADDITIONAL TOOLS
# =====================================================

echo -e "\n${YELLOW}Installing Additional Tools...${NC}"

# HTTPie - Human-friendly HTTP client
if ! command_exists http; then
    echo -e "${GREEN}Installing HTTPie...${NC}"
    install_package httpie httpie httpie
else
    echo -e "${BLUE}HTTPie already installed${NC}"
fi

# jq - JSON processor
if ! command_exists jq; then
    echo -e "${GREEN}Installing jq...${NC}"
    install_package jq jq jq
else
    echo -e "${BLUE}jq already installed${NC}"
fi

# yq - YAML processor
if ! command_exists yq; then
    echo -e "${GREEN}Installing yq...${NC}"
    install_package yq yq yq
else
    echo -e "${BLUE}yq already installed${NC}"
fi

# Glow - Markdown renderer
if ! command_exists glow; then
    echo -e "${GREEN}Installing Glow...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install glow
    else
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install glow
    fi
else
    echo -e "${BLUE}Glow already installed${NC}"
fi

# duf - Better df
if ! command_exists duf; then
    echo -e "${GREEN}Installing duf...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install duf
    else
        curl -Lo duf.deb "https://github.com/muesli/duf/releases/latest/download/duf_$(dpkg --print-architecture).deb"
        sudo dpkg -i duf.deb
        rm duf.deb
    fi
else
    echo -e "${BLUE}duf already installed${NC}"
fi

# ncdu - NCurses disk usage
if ! command_exists ncdu; then
    echo -e "${GREEN}Installing ncdu...${NC}"
    install_package ncdu ncdu ncdu
else
    echo -e "${BLUE}ncdu already installed${NC}"
fi

# =====================================================
# ZSH PLUGINS
# =====================================================

echo -e "\n${YELLOW}Installing ZSH Plugins...${NC}"

# Install zinit (plugin manager)
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    echo -e "${GREEN}Installing Zinit...${NC}"
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
    echo -e "${BLUE}Zinit already installed${NC}"
fi

# =====================================================
# TMUX PLUGIN MANAGER
# =====================================================

echo -e "\n${YELLOW}Installing Tmux Plugin Manager...${NC}"

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo -e "${GREEN}Installing TPM...${NC}"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo -e "${BLUE}TPM already installed${NC}"
fi

# =====================================================
# CONFIGURATION
# =====================================================

echo -e "\n${YELLOW}Setting up configurations...${NC}"

# Create config directories
mkdir -p ~/.config/{starship,bat,git}

# Link Starship config
if [ -f ~/dotfiles/starship/starship.toml ]; then
    ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship/starship.toml
    echo -e "${GREEN}✓ Linked Starship config${NC}"
fi

# Configure git to use delta
if command_exists delta; then
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    echo -e "${GREEN}✓ Configured git to use delta${NC}"
fi

# Configure bat
if command_exists bat; then
    bat cache --build >/dev/null 2>&1 || true
    echo -e "${GREEN}✓ Built bat cache${NC}"
fi

# =====================================================
# FINAL STEPS
# =====================================================

echo -e "\n${BLUE}=================================================${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${BLUE}=================================================${NC}"

echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Restart your terminal or run: ${GREEN}source ~/.zshrc${NC}"
echo -e "2. Install tmux plugins: ${GREEN}prefix + I${NC} (inside tmux)"
echo -e "3. Update TLDR database: ${GREEN}tldr --update${NC}"

echo -e "\n${YELLOW}Optional tools to install manually:${NC}"
echo -e "- ${BLUE}fastfetch${NC} or ${BLUE}neofetch${NC} - System info display"
echo -e "- ${BLUE}ranger${NC} or ${BLUE}lf${NC} - Terminal file manager"
echo -e "- ${BLUE}gping${NC} - Ping with graph"
echo -e "- ${BLUE}dog${NC} - DNS lookup (better dig)"
echo -e "- ${BLUE}procs${NC} - Modern ps"
echo -e "- ${BLUE}sd${NC} - Intuitive find & replace"
echo -e "- ${BLUE}dust${NC} - More intuitive du"
echo -e "- ${BLUE}bottom${NC} - Another system monitor"

echo -e "\n${GREEN}Enjoy your modern CLI setup! 🚀${NC}"