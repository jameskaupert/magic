#!/bin/bash

set -e

echo "📁 Setting up workspace structure..."

# Create the standard workspace structure
WORKSPACE_ROOT="$HOME/workspaces/github.com/jameskaupert"
mkdir -p "$WORKSPACE_ROOT"

echo "✅ Created workspace structure: $WORKSPACE_ROOT"

# If we're not already in the workspace, move there
CURRENT_MAGIC_PATH="$(pwd)"
TARGET_MAGIC_PATH="$WORKSPACE_ROOT/magic"

if [[ "$CURRENT_MAGIC_PATH" != "$TARGET_MAGIC_PATH" ]]; then
  echo "📦 Moving magic repository to proper workspace location..."

  # If target already exists, back it up
  if [[ -d "$TARGET_MAGIC_PATH" ]]; then
    echo "⚠️  Backing up existing magic directory..."
    mv "$TARGET_MAGIC_PATH" "$TARGET_MAGIC_PATH.backup.$(date +%Y%m%d_%H%M%S)"
  fi

  # Move current directory to workspace
  mv "$CURRENT_MAGIC_PATH" "$TARGET_MAGIC_PATH"

  echo "✅ Repository moved to: $TARGET_MAGIC_PATH"
  echo "💡 Please cd to the new location: cd $TARGET_MAGIC_PATH"
else
  echo "✅ Already in proper workspace location"
fi
