# 🚀 Universal Dotfiles

Centralized configuration for all my machines - macOS, Linux, and remote servers.

## ✨ Features

- **Universal configs** - Same experience everywhere
- **Automatic sync** - Keep all machines in sync
- **MCP support** - Claude Desktop configs included
- **Smart detection** - OS-specific settings when needed
- **Easy installation** - One command setup

## 📦 What's Included

- **ZSH** - Oh My Zsh with productivity plugins
- **TMUX** - Universal multiplexer config
- **MCP** - Claude Desktop server configurations
- **Scripts** - Helpful automation tools

## 🚀 Quick Install

### On a new machine:
```bash
git clone https://github.com/parimple/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Or one-liner:
```bash
curl -sL https://raw.githubusercontent.com/parimple/dotfiles/main/install.sh | bash
```

## 📖 Usage

### Sync everything:
```bash
cd ~/dotfiles
./sync.sh
```

### Sync to remote hosts:
```bash
./sync.sh  # Will ask about each remote host
```

### Local only sync:
```bash
./sync.sh --local
```

### Sync MCP configs:
```bash
~/bin/sync-mcp.sh
```

## 🔧 Configuration

### Add a new remote host:
Edit `sync.sh` and add to `REMOTE_HOSTS` array:
```bash
REMOTE_HOSTS=("oracle" "evertz" "newhost")
```

### Customize locally:
- `~/.tmux.local.conf` - Local tmux overrides
- `~/.zshrc.local` - Local zsh additions

## 📁 Structure

```
dotfiles/
├── zsh/
│   ├── zshrc          # Main ZSH config
│   └── aliases        # Shared aliases
├── tmux/
│   ├── tmux.conf      # Main TMUX config
│   └── tmux-universal.conf  # Minimal universal config
├── mcp/
│   └── claude_desktop_config.json  # MCP servers config
├── scripts/
│   └── sync-mcp.sh    # MCP sync script
├── sync.sh            # Main sync script
├── install.sh         # Installation script
└── README.md          # This file
```

## 🔄 Keeping in Sync

### Manual sync:
```bash
cd ~/dotfiles && ./sync.sh
```

### Auto sync (add to crontab):
```bash
0 */6 * * * cd ~/dotfiles && git pull && ./sync.sh --local
```

## 🛠️ Troubleshooting

### Permission issues:
```bash
chmod +x ~/dotfiles/*.sh ~/dotfiles/scripts/*.sh
```

### MCP paths not working:
```bash
brew install jq  # Required for path updates
~/bin/sync-mcp.sh
```

### Conflicts during sync:
Check backup directory shown after sync completes.

## 📝 Notes

- Configs are OS-aware (macOS vs Linux)
- MCP only syncs on macOS (where Claude Desktop runs)
- Backups are created before overwriting
- Git commits are automatic on sync

## 🤖 Claude Code Integration

This dotfiles setup is **optimized for Claude Code** workflows:

### CLAUDE.md - Project Context System
Every project should have a `CLAUDE.md` file that provides Claude with essential context:

```bash
# Quick create in any project
claude-init  # Creates CLAUDE.md from template
```

**CLAUDE.md tells Claude:**
- How to understand your project structure
- What coding standards to follow
- Which commands to use for testing/building
- Project-specific instructions

See [CLAUDE-USAGE.md](docs/CLAUDE-USAGE.md) for complete guide and [examples](examples/).

### MCP Server Management
```bash
mcplist          # List all configured MCP servers
mcpdebug         # Interactive debugging menu
mcplog           # Real-time log monitoring
mcp-test SERVER  # Test specific server
```

### AI-Optimized Tools
Install modern CLI tools that provide clean output for Claude:
```bash
./scripts/install-ai-tools.sh
```

This installs:
- **ripgrep** - 5-10x faster search with AI-friendly output
- **fd** - Intuitive file finding (replaces find)
- **bat** - Syntax highlighting for code review
- **jq/yq** - JSON/YAML processing
- Plus many more productivity tools

## 🚧 TODO

- [ ] Add automatic GitHub push
- [ ] Add more shell themes
- [ ] Include VS Code settings
- [ ] Add brew bundle for macOS

---
*Remember to update the repository URL in install.sh!*