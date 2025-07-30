#!/bin/bash

set -e

# Configuration
DOTFILES_REPO="${DOTFILES_REPO:-git@github.com:jameskaupert/dotfiles.git}"

echo "🚀 Magic System Setup"
echo "===================="
echo "📋 Using dotfiles: $DOTFILES_REPO"
echo ""

# Create workspace structure
echo "📁 Setting up workspace structure..."
WORKSPACE_ROOT="$HOME/workspace/github.com/jameskaupert"
mkdir -p "$WORKSPACE_ROOT"

# Move to proper location if needed
CURRENT_MAGIC_PATH="$(pwd)"
TARGET_MAGIC_PATH="$WORKSPACE_ROOT/magic"

if [[ "$CURRENT_MAGIC_PATH" != "$TARGET_MAGIC_PATH" ]]; then
  echo "📦 Moving magic repository to workspace location..."

  if [[ -d "$TARGET_MAGIC_PATH" ]]; then
    echo "⚠️  Backing up existing magic directory..."
    mv "$TARGET_MAGIC_PATH" "$TARGET_MAGIC_PATH.backup.$(date +%Y%m%d_%H%M%S)"
  fi

  mv "$CURRENT_MAGIC_PATH" "$TARGET_MAGIC_PATH"
  echo "✅ Repository moved to: $TARGET_MAGIC_PATH"
  cd "$TARGET_MAGIC_PATH"
else
  echo "✅ Already in proper workspace location"
fi

# Install system packages and services via Ansible
echo "🔧 Installing system packages and services..."
if ! command -v ansible-playbook &>/dev/null; then
  echo "📦 Installing Ansible..."
  sudo pacman -S --noconfirm ansible
fi

ansible-playbook ansible/system.yml --ask-become-pass --extra-vars "target_user=$USER"

# Install chezmoi
echo "📋 Installing chezmoi..."
if ! command -v chezmoi >/dev/null; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  # Add ~/.local/bin to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
fi

# Apply personal configurations with chezmoi
echo "🏠 Applying personal configurations..."
chezmoi init --apply "$DOTFILES_REPO"

# Initialize mise for development tools
echo "🛠️  Initializing mise for development tools..."
if command -v mise >/dev/null; then
  mise install
else
  echo "⚠️  mise not found, you may need to restart your shell first"
fi

echo ""
echo "🎉 Setup complete!"
echo "💡 Required next step:"
echo "   1. Reboot your system"
echo "      (Required for Docker group membership and greetd config to take effect)"
echo ""
echo "💡 After reboot, verify:"
echo "   2. Docker access: docker run hello-world"
echo "   3. Greeter functionality"
echo "   4. Development tools: mise list"
echo ""
echo "📍 Magic repository location: $TARGET_MAGIC_PATH"

