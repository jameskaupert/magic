#!/bin/bash
set -euo pipefail

echo "🔧 Setting up personal tools and configurations..."

# Change shell to zsh if available and preferred
if command -v zsh >/dev/null; then
  if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    echo "🐚 Changing shell to zsh..."
    sudo chsh -s $(command -v zsh) $USER
  fi
fi

# Create zsh directory if needed
if [ ! -d "$HOME/.zsh" ]; then
  mkdir -p "$HOME/.zsh"
fi

# Install oh-my-posh
if ! command -v oh-my-posh >/dev/null; then
  echo "🎨 Installing oh-my-posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Install zoxide
if ! command -v zoxide >/dev/null; then
  echo "📂 Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

npm install -g @anthropic-ai/claude-code

echo "✅ Personal tools setup complete!"
