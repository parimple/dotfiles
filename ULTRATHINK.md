# 🚀 UltraThink - Terminal Configuration Automation

UltraThink is an intelligent tool that automatically optimizes your terminal setup based on Reddit community best practices.

## Features

- 🔍 **Analyzes** your current ZSH, tmux, and MCP configurations
- 🌐 **Fetches** popular configurations from Reddit (r/unixporn, r/zsh, r/tmux, etc.)
- ⚡ **Optimizes** your setup based on community recommendations
- 🔧 **Installs** missing productivity tools automatically
- 🔄 **Synchronizes** configurations across all your machines
- 🛡️ **Backs up** existing configurations before making changes

## What It Does

1. **Configuration Analysis**
   - Scans your current .zshrc, .tmux.conf, and MCP settings
   - Identifies installed vs missing tools
   - Extracts current plugins, aliases, and functions

2. **Reddit Integration**
   - Fetches top-rated configurations from relevant subreddits
   - Analyzes posts with 100+ upvotes for configuration patterns
   - Extracts popular plugins, tools, and settings

3. **Intelligent Optimization**
   - Merges your existing setup with Reddit's best practices
   - Keeps your current settings while adding popular enhancements
   - Generates OS-aware configurations (macOS vs Linux)

4. **Automatic Tool Installation**
   - Installs popular tools like fzf, ripgrep, bat, eza, zoxide
   - Handles different package managers (Homebrew, apt)
   - Configures tools automatically

5. **Multi-Machine Sync**
   - Syncs to Oracle (user: ubuntu) and Evertz (user: ppyzel)
   - Handles different usernames and paths
   - Maintains compatibility across systems

## Installation

```bash
cd ~/dotfiles
./install-ultrathink.sh
source ~/.zshrc
```

## Usage

### Full Optimization (Recommended)
```bash
ultrathink
```
This will:
- Backup current configs
- Analyze your setup
- Fetch Reddit recommendations
- Optimize configurations
- Install missing tools
- Sync across all machines

### Analyze Only
```bash
ultrathink --analyze-only
```
Shows current configuration analysis without making changes.

### Skip Reddit Fetching
```bash
ultrathink --skip-reddit
```
Uses built-in best practices without fetching from Reddit.

## What Gets Optimized

### ZSH Configuration
- **Plugins**: Adds popular Oh My Zsh plugins based on Reddit votes
- **Aliases**: Includes community-favorite shortcuts
- **Functions**: Adds helpful utility functions
- **Performance**: Implements speed optimizations
- **Prompt**: Installs Starship for a modern, fast prompt

### TMUX Configuration  
- **Key Bindings**: Vim-style navigation
- **Mouse Support**: Toggle-able mouse mode
- **Status Bar**: Clean, informative status line
- **Plugins**: TPM with essential plugins
- **OS Integration**: Platform-specific clipboard support

### Productivity Tools
Based on Reddit popularity scores:
- `fzf` - Fuzzy finder (2500+ upvotes)
- `ripgrep` - Better grep (2200+ upvotes)  
- `bat` - Better cat with syntax highlighting (1900+ upvotes)
- `eza` - Modern ls replacement (1700+ upvotes)
- `zoxide` - Smarter cd (1600+ upvotes)
- `starship` - Fast, customizable prompt (2000+ upvotes)
- `lazygit` - Terminal UI for git (1500+ upvotes)
- And many more...

## Popular Configurations Added

### Aliases (Reddit Favorites)
```bash
alias ll='ls -alF'          # Detailed list
alias g='git'               # Git shortcut
alias k='kubectl'           # Kubernetes
alias d='docker'            # Docker
alias ..='cd ..'            # Parent directory
alias vim='nvim'            # Neovim
alias cat='bat'             # Better cat
alias ls='eza'              # Better ls
alias find='fd'             # Better find
alias grep='rg'             # Better grep
```

### Functions
```bash
mkcd()      # Make directory and cd into it
extract()   # Extract any archive format
backup()    # Quick backup with timestamp
gclone()    # Clone and cd into repo
```

### ZSH Plugins (Top Voted)
- zsh-autosuggestions (2500+ upvotes)
- zsh-syntax-highlighting (2400+ upvotes)
- fzf (2200+ upvotes)
- thefuck (1600+ upvotes)
- z/autojump (1500+ upvotes)

## Backup Location

All original configurations are backed up to:
```
~/.ultrathink_backups/YYYYMMDD_HHMMSS/
```

## How It Works

1. **Backup Phase**: Saves current configs locally and from remote servers
2. **Analysis Phase**: Parses configuration files to understand current setup
3. **Reddit Phase**: Fetches top posts from terminal-related subreddits
4. **Optimization Phase**: Merges current setup with Reddit best practices
5. **Generation Phase**: Creates new optimized configuration files
6. **Installation Phase**: Installs missing tools on all systems
7. **Sync Phase**: Pushes to git and syncs across all machines

## Safety Features

- Creates timestamped backups before any changes
- Validates configurations before applying
- Handles OS-specific differences automatically
- Skips VS Code SSH sessions for tmux auto-start
- Uses non-destructive merging (keeps your customizations)

## Customization

After running UltraThink, you can further customize by editing:
- `~/.zshrc.local` - Local ZSH additions
- `~/.tmux.local.conf` - Local tmux overrides
- `~/dotfiles/config/starship.toml` - Prompt customization

## Troubleshooting

### Tools not installing on remote servers
- Ensure you have sudo access
- Check internet connectivity
- Some tools may need manual installation

### Configuration not applying
- Run `source ~/.zshrc` after installation
- Restart tmux sessions
- Check for syntax errors in generated configs

### Reddit fetching fails
- Use `--skip-reddit` flag
- Check internet connectivity
- Reddit API may be rate limited

## Future Enhancements

- [ ] Vim/Neovim configuration optimization
- [ ] VS Code settings sync
- [ ] Automatic cron job for regular updates
- [ ] Configuration rollback feature
- [ ] Custom theme selection
- [ ] Performance benchmarking

---

*UltraThink - Making your terminal ultra-productive with the wisdom of Reddit!*