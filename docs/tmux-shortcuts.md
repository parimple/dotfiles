# Tmux Shortcuts Reference

## Window Navigation (NO PREFIX NEEDED!)

### 🎯 BEST FOR macOS:
- **`Option+[`** - Previous window (EASIEST!)
- **`Option+]`** - Next window (EASIEST!)
- **`Option+Tab`** - Next window (like browser)
- **`Option+Shift+Tab`** - Previous window
- **`Option+j`** - Previous window (vim style)
- **`Option+k`** - Next window (vim style)

### Quick Window Switching
- **`Ctrl+1` to `Ctrl+9`** - Jump directly to window 1-9
- **`F1` to `F4`** - Jump to window 1-4
- **`Option+Shift+←/→`** - Previous/Next window
- **`PageUp/PageDown`** - Previous/Next window
- **`Alt+h` / `Alt+l`** - Previous/Next window (vim style)
- **`Alt+Tab`** - Switch to last used window

### Window Management
- **`Alt+n`** - Create new window
- **`Alt+w`** - Close current window (with confirmation)
- **`Ctrl+Shift+←/→`** - Move window left/right

## Pane Navigation (NO PREFIX NEEDED!)

- **`Alt+Arrow Keys`** - Switch between panes
- **`Alt+h/j/k/l`** - Switch panes (vim style) - requires prefix

## Copy/Paste

- **Mouse OFF by default** - Normal text selection works
- **`Ctrl+a m`** - Turn mouse ON (for scrolling)
- **`Ctrl+a M`** - Turn mouse OFF (for copying)
- **`Ctrl+[`** - Enter copy mode
- In copy mode:
  - **`v`** - Start selection
  - **`y`** - Copy selection
  - **`/`** - Search forward
  - **`?`** - Search backward

## Other Useful Shortcuts

- **`Ctrl+a r`** - Reload tmux config
- **`Ctrl+a |`** or **`Ctrl+a \`** - Split vertically
- **`Ctrl+a -`** or **`Ctrl+a _`** - Split horizontally
- **`Ctrl+a z`** - Zoom pane (toggle)
- **`Ctrl+a d`** - Detach from session

## Session Management

- **`Ctrl+a s`** - List sessions
- **`Ctrl+a S`** - Create new session
- **`Ctrl+a $`** - Rename session

## macOS Terminal Tips

In Apple Terminal, make sure to:
1. Go to Terminal → Preferences → Profiles → Keyboard
2. Check "Use Option as Meta key"
3. This enables Option key combinations

For best tmux experience on macOS, consider using iTerm2:
```bash
brew install --cask iterm2
```