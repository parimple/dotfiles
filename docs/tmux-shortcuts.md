# Tmux Shortcuts Reference

## Window Navigation (NO PREFIX NEEDED!)

### Quick Window Switching
- **`Ctrl+1` to `Ctrl+9`** - Jump directly to window 1-9
- **`Alt+Left/Right Arrow`** - Previous/Next window  
- **`Alt+Shift+Left/Right`** - Previous/Next window (alternative)
- **`Alt+h` / `Alt+l`** - Previous/Next window (vim style)
- **`Alt+Tab`** - Switch to last used window

### Window Management
- **`Alt+n`** - Create new window
- **`Alt+w`** - Close current window (with confirmation)

### With Prefix (Ctrl+a)
- **`Ctrl+a c`** - Create new window
- **`Ctrl+a n`** - Next window
- **`Ctrl+a p`** - Previous window
- **`Ctrl+a Tab`** - Last window
- **`Ctrl+a [number]`** - Go to window number

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