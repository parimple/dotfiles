# Modern Dotfiles - Reddit Community Edition 🚀

A modern, highly optimized dotfiles setup based on the most upvoted configurations from r/unixporn, r/zsh, r/tmux, and r/commandline.

## 🌟 Features

### Core Tools (Reddit's Top Picks)
- **[Starship](https://starship.rs/)** - The minimal, blazing-fast, and infinitely customizable prompt
- **[FZF](https://github.com/junegunn/fzf)** - The ultimate fuzzy finder (#1 productivity tool on Reddit)
- **[Eza](https://github.com/eza-community/eza)** - Modern replacement for `ls` with icons and Git integration
- **[Bat](https://github.com/sharkdp/bat)** - `cat` with syntax highlighting and Git integration
- **[Ripgrep](https://github.com/BurntSushi/ripgrep)** - Blazingly fast grep alternative
- **[fd](https://github.com/sharkdp/fd)** - Fast and user-friendly alternative to `find`
- **[Zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter `cd` that learns your habits
- **[Delta](https://github.com/dandavison/delta)** - Beautiful Git diffs with syntax highlighting
- **[Lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for Git
- **[Btop](https://github.com/aristocratos/btop)** - Resource monitor with beautiful UI

### ZSH Configuration
- **Zinit** plugin manager for blazing fast startup
- **Essential plugins**: autosuggestions, syntax highlighting, history substring search
- **Optimized settings** for performance and usability
- **500+ aliases** for modern CLI tools
- **FZF integration** for history, files, Git branches, and more

### TMUX Configuration
- **Vim-style navigation** with smart pane switching
- **Popup windows** for quick commands (tmux 3.2+)
- **Session persistence** with tmux-resurrect and continuum
- **Beautiful status bar** with system information
- **Extensive key bindings** for productivity

## 📦 Installation

### Quick Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/parimple/dotfiles.git ~/dotfiles

# Run the enhanced sync script
cd ~/dotfiles
bash sync-enhanced.sh --enhanced

# Install modern CLI tools
bash scripts/install-modern-tools.sh
```

### Manual Installation

1. **Install prerequisites**:
   ```bash
   # macOS
   brew install git curl wget

   # Ubuntu/Debian
   sudo apt update && sudo apt install -y git curl wget build-essential
   ```

2. **Clone and sync**:
   ```bash
   git clone https://github.com/parimple/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   bash sync-enhanced.sh --enhanced --local
   ```

3. **Install tools**:
   ```bash
   bash scripts/install-modern-tools.sh
   ```

## 🎯 Usage

### FZF Shortcuts (Most Loved)

| Shortcut | Description |
|----------|-------------|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy find files |
| `Alt+C` | Fuzzy change directory |
| `fcd` | Interactive directory navigation with preview |
| `fe` | Fuzzy find and edit files |
| `fkill` | Fuzzy find and kill processes |
| `fbr` | Fuzzy checkout Git branches |
| `fshow` | Browse Git commits interactively |
| `frg` | Interactive ripgrep with preview |

### Modern CLI Replacements

| Old Command | New Command | Description |
|-------------|-------------|-------------|
| `ls` | `eza` | Lists with icons and Git status |
| `cat` | `bat` | Syntax highlighting and line numbers |
| `grep` | `rg` | 10x faster with better defaults |
| `find` | `fd` | Intuitive syntax and faster |
| `cd` | `z` | Jumps to frecent directories |
| `git diff` | `delta` | Side-by-side diffs with syntax highlighting |
| `top` | `btop` | Beautiful resource monitor |
| `man` | `tldr` | Practical examples instead of walls of text |

### TMUX Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+a` | Prefix key |
| `Prefix + Space` | Quick floating terminal |
| `Prefix + g` | Lazygit popup |
| `Prefix + m` | System monitor popup |
| `Prefix + s` | Session switcher with preview |
| `Prefix + \|` | Split vertically |
| `Prefix + -` | Split horizontally |
| `Ctrl+h/j/k/l` | Navigate panes (works with Vim) |
| `Prefix + r` | Reload config |

### Git Aliases (Most Used)

```bash
g s          # git status (short format)
g l          # pretty log with graph
g cm "msg"   # quick commit
g aa         # add all files
g cob name   # create and checkout branch
g save       # quick save (add all + commit)
g undo       # undo last commit, keep changes
```

## 🛠️ Customization

### Add Your Own Configs

1. Create `~/.zshrc.local` for personal ZSH settings
2. Create `~/.tmux.conf.local` for personal TMUX settings
3. These files won't be synced and will be loaded automatically

### Switch Between Configurations

```bash
# Use original configs
bash sync.sh --local

# Use enhanced configs
bash sync-enhanced.sh --enhanced --local
```

### Add New Tools

Edit `scripts/install-modern-tools.sh` to add your favorite tools.

## 🔧 Troubleshooting

### Slow ZSH startup?
```bash
# Profile your startup time
zsh -xvs 2>&1 | ts -s %.s > zsh-startup.log

# Consider lazy loading NVM (already configured)
```

### FZF not working?
```bash
# Reinstall FZF
~/.fzf/install --all
```

### TMUX plugins not loading?
```bash
# Inside tmux, press: prefix + I
# Or manually:
~/.tmux/plugins/tpm/bin/install_plugins
```

### Fonts look weird?
Install a Nerd Font: https://www.nerdfonts.com/
Recommended: JetBrainsMono Nerd Font

## 📚 Resources

- [r/unixporn](https://reddit.com/r/unixporn) - Where these configs were inspired
- [r/commandline](https://reddit.com/r/commandline) - CLI tool discussions
- [Modern Unix](https://github.com/ibraheemdev/modern-unix) - Collection of modern CLI tools
- [Awesome Shell](https://github.com/alebcay/awesome-shell) - Curated shell resources

## 🤝 Contributing

Feel free to submit PRs with your favorite tools or optimizations!

## 📝 License

MIT - Use these configs freely!

---

**Enjoy your modern, blazing-fast terminal setup!** 🚀

*Based on thousands of upvotes from the Reddit community*