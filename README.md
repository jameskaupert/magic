# magic

Unified personal computing environment setup for Arch Linux.

## Architecture

- **Ansible:** System packages and services
- **Chezmoi:** Personal dotfiles and tools  
- **Mise:** Development tool versions

## Quick Start

```bash
git clone https://github.com/jameskaupert/magic.git
cd magic
./setup.sh
```

This sets up workspace structure, installs system packages, applies personal configs, and initializes development tools.

### Using Custom Dotfiles

To use a different dotfiles repository:

```bash
DOTFILES_REPO="git@github.com:username/dotfiles.git" ./setup.sh
```

The dotfiles repository should be chezmoi-compatible and optionally include mise configuration.
