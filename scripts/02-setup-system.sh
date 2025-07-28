#!/bin/bash

set -e

# First, set up workspace structure
echo "📁 Setting up workspace structure..."
./scripts/01-setup-workspace.sh

# Ensure we're in the magic directory within workspace
MAGIC_DIR="$HOME/workspaces/github.com/jameskaupert/magic"
if [[ "$(pwd)" != "$MAGIC_DIR" ]]; then
  echo "📍 Changing to magic directory: $MAGIC_DIR"
  cd "$MAGIC_DIR"
fi

# Verify Ansible is available
if ! command -v ansible-playbook &>/dev/null; then
  echo "📦 Installing Ansible first..."
  sudo pacman -S --noconfirm ansible
fi

# Run the system configuration
echo "🔧 Running system configuration..."
ansible-playbook ansible/system.yml --ask-become-pass

# Verify services are running
echo "✅ Verifying services..."
sudo systemctl status greetd --no-pager
sudo systemctl status docker --no-pager

# Test Docker works
echo "🐳 Testing Docker..."
docker run hello-world

echo "🎉 Laptop setup complete!"
echo "💡 You can now test the greeter by logging out"
echo "💡 Magic repository location: $MAGIC_DIR"
echo "💡 Next steps:"
echo "   1. Test the greeter experience"
echo "   2. Set up chezmoi for personal configs: ./scripts/setup-chezmoi.sh"
echo "   3. Install mise for development tools: ./scripts/setup-mise.sh"
