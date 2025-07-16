#!/bin/bash
# UltraThink Installation Script

set -e

echo "🚀 Installing UltraThink dependencies..."

# Install Python dependencies
pip3 install --user requests pathlib

# Make ultrathink executable
chmod +x ultrathink.py

# Create symlink for easy access
mkdir -p ~/bin
ln -sf ~/dotfiles/ultrathink.py ~/bin/ultrathink

# Add ~/bin to PATH if not already there
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.zshrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
fi

echo "✅ UltraThink installed successfully!"
echo ""
echo "Usage:"
echo "  ultrathink          - Run full optimization"
echo "  ultrathink --analyze-only  - Only analyze current setup"
echo "  ultrathink --skip-reddit   - Use built-in recommendations"
echo ""
echo "Run 'source ~/.zshrc' to update your PATH"