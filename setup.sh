#!/bin/bash

set -e

echo "🚀 Magic System Setup"
echo "===================="

# Create workspace structure
echo "📁 Setting up workspace structure..."
WORKSPACE_ROOT="$HOME/workspaces/github.com/jameskaupert"
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
chezmoi init --source="$TARGET_MAGIC_PATH/chezmoi-source" --apply

# Initialize mise for development tools
echo "🛠️  Initializing mise for development tools..."
if command -v mise >/dev/null; then
  mise install
else
  echo "⚠️  mise not found, you may need to restart your shell first"
fi

# Verify services
echo "✅ Verifying system services..."
sudo systemctl status greetd --no-pager
sudo systemctl status docker --no-pager

echo ""
echo "🎉 Setup complete!"
echo "💡 Required next step:"
echo "   1. Logout completely from your desktop session and log back in"
echo "      (This is required for Docker group membership to take effect)"
echo ""
echo "💡 After logout/login, verify:"
echo "   2. Docker access: docker run hello-world"
echo "   3. Greeter functionality"
echo "   4. Development tools: mise list"
echo ""
echo "📍 Magic repository location: $TARGET_MAGIC_PATH"