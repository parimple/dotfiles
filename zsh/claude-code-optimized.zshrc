# Claude Code Optimized ZSH Configuration - Based on 2025 Research
# ================================================================
# Minimal, fast, AI-parseable configuration

# Essential Environment Variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R -F -X'

# Path configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Load secure environment variables
[ -f ~/.env ] && source ~/.env

# ==========================================
# MINIMAL PROMPT FOR AI PARSING
# ==========================================
# Clean, simple prompt that Claude can parse easily
export PS1=$'\n%F{green}%*%f %3~ %F{white}\n$ %f'

# Disable all colors for better AI parsing
export CLICOLOR=1
unset LSCOLORS

# ==========================================
# HISTORY OPTIMIZATION
# ==========================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# ==========================================
# CLAUDE CODE SPECIFIC ALIASES
# ==========================================
# MCP Management
alias mcplist='claude mcp list'
alias mcpstatus='claude mcp status'
alias mcplog='tail -f ~/Library/Logs/Claude/*.log'
alias mcpdebug='npx @modelcontextprotocol/inspector'
alias mcptest='claude mcp test'

# Claude Code shortcuts
alias cc='claude'
alias ccc='claude chat'
alias cchelp='claude --help'
alias ccversion='claude --version'

# Debugging
alias claude-log='tail -f ~/Library/Logs/Claude/claude.log'
alias claude-errors='grep -i error ~/Library/Logs/Claude/*.log | tail -20'
alias claude-clear='rm -f ~/Library/Logs/Claude/*.log'

# Project management
alias claude-init='touch CLAUDE.md && echo "# Project Context for Claude" > CLAUDE.md'
alias claude-context='cat CLAUDE.md 2>/dev/null || echo "No CLAUDE.md found"'

# ==========================================
# MCP-SPECIFIC FUNCTIONS
# ==========================================
# Test MCP server
mcp-test() {
    local server=$1
    if [ -z "$server" ]; then
        echo "Usage: mcp-test <server-name>"
        return 1
    fi
    npx @modelcontextprotocol/inspector $(claude mcp list | grep "^$server:" | cut -d' ' -f2-)
}

# Start MCP server in debug mode
mcp-debug() {
    local server=$1
    export DEBUG=mcp:*
    claude mcp start "$server"
}

# Validate MCP configuration
mcp-validate() {
    local config_file="${1:-~/.claude/mcp.json}"
    if [ -f "$config_file" ]; then
        jq . "$config_file" >/dev/null 2>&1 && echo "✓ Valid JSON" || echo "✗ Invalid JSON"
        jq '.servers | keys[]' "$config_file" 2>/dev/null | while read -r server; do
            echo "  - $server"
        done
    else
        echo "Config file not found: $config_file"
    fi
}

# ==========================================
# MODERN CLI TOOLS (AI-FRIENDLY OUTPUT)
# ==========================================
# Use ripgrep for fast, clean searching
alias grep='rg'
alias g='rg'

# Use fd for intuitive file finding
alias find='fd'
alias f='fd'

# Use bat for syntax-highlighted file viewing
alias cat='bat --style=plain'
alias catn='bat --style=numbers'

# Use eza for better ls
alias ls='eza --no-icons --group-directories-first'
alias ll='eza -la --no-icons --group-directories-first'
alias lt='eza --tree --no-icons -L 2'

# JSON/YAML processing
alias json='jq .'
alias yaml='yq .'
alias jsont='jq . | bat -l json'

# ==========================================
# TMUX INTEGRATION FOR AI WORKFLOWS
# ==========================================
# Auto-start tmux for SSH sessions (AI-friendly)
if [[ -n "$SSH_CLIENT" ]] && [[ -z "$TMUX" ]] && [[ -z "$VSCODE_INJECTION" ]]; then
    tmux new-session -A -s main
fi

# Tmux aliases for AI workflows
alias tmai='tmux new-window -n ai "tmuxai --watch"'
alias tmlog='tmux pipe-pane -o "cat >> ~/tmux-#S-#W.log"'
alias tmclear='tmux clear-history'

# ==========================================
# SSH OPTIMIZATIONS FOR MCP
# ==========================================
# Connection multiplexing for stable MCP connections
alias ssh='ssh -o ControlMaster=auto -o ControlPath=~/.ssh/control:%h:%p:%r -o ControlPersist=4h'

# Quick connections with tmux
alias ssho='ssh -t oracle tmux new-session -A -s main'
alias sshe='ssh -t evertz tmux new-session -A -s main'

# ==========================================
# PERFORMANCE OPTIMIZATIONS
# ==========================================
# Lazy load NVM (saves ~500ms)
export NVM_LAZY_LOAD=true
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}

# Lazy load pyenv (saves ~200ms)
pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
}

# ==========================================
# MINIMAL COMPLETION SETUP
# ==========================================
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi

# Basic completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ==========================================
# KEY BINDINGS FOR PRODUCTIVITY
# ==========================================
# Better history search
bindkey '^R' history-incremental-search-backward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Quick directory navigation
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# ==========================================
# FINAL SETUP
# ==========================================
# Source local overrides if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Quick help function
claude-help() {
    echo "Claude Code Productivity Commands:"
    echo "  mcplist         - List MCP servers"
    echo "  mcplog          - View MCP logs"
    echo "  mcp-test SERVER - Test MCP server"
    echo "  claude-init     - Initialize CLAUDE.md"
    echo "  tmai            - Start TmuxAI in new window"
    echo ""
    echo "Performance Tips:"
    echo "  - Shell starts in <0.6s with lazy loading"
    echo "  - Use 'rg' instead of grep (5-10x faster)"
    echo "  - Use 'fd' instead of find (3-5x faster)"
    echo "  - MCP logs: ~/Library/Logs/Claude/"
}

# Show startup time in debug mode
if [[ -n "$DEBUG_SHELL" ]]; then
    echo "Shell started in: $(($(date +%s%N)/1000000 - $SHELL_START_TIME))ms"
fi