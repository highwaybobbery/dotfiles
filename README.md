# Alex Berry Dotfiles & Development Tools

Personal dotfiles and development toolkit for working across multiple code repositories and organizations.

## Overview

This repository contains:
- **Dotfiles**: Shell configuration, aliases, and environment setup
- **Development Scripts**: Ruby utilities for repository management and project setup
- **Configuration Files**: Git, Vim, Tmux, and terminal configurations

## Directory Structure

```
.
├── scripts/              # Ruby development utilities
│   ├── add_repo.rb      # Add repositories to tracking system
│   └── clone_project.rb # Clone repositories into workspace structure
├── config/              # Configuration files for various tools
│   ├── alacritty/       # Terminal emulator configuration
│   └── nvim/            # Neovim configuration
├── aliases              # Shell aliases
├── zshrc               # Zsh configuration
├── vimrc               # Vim configuration
├── tmux.conf           # Tmux configuration
├── gitconfig           # Git configuration
├── install.sh          # Dotfiles installation script
└── uninstall.sh        # Dotfiles removal script
```

## Development Scripts

### Repository Management

The `scripts/` directory contains Ruby utilities for managing repositories across multiple organizations:

#### add_repo.rb
Adds repositories to the tracking system and optionally clones them.

**Usage:**
```bash
./scripts/add_repo.rb <owner/repo_name>
./scripts/add_repo.rb <full_git_url>
```

**Examples:**
```bash
./scripts/add_repo.rb kin/dot-com
./scripts/add_repo.rb highwaybobbery/dotfiles
./scripts/add_repo.rb git@github.com:kin/dot-com.git
```

#### clone_project.rb
Clones repositories into standardized workspace directories.

**Usage:**
```bash
./scripts/clone_project.rb <owner/repo_name>
```

**Example:**
```bash
./scripts/clone_project.rb kin/dot-com
```

### Workspace Structure

All projects follow a consistent workspace structure organized by owner:

```
~/Projects/
├── kin/
│   ├── dot-com-workspace/
│   │   └── main/           # Main branch checkout
│   └── rater-api-workspace/
│       └── main/           # Main branch checkout
└── highwaybobbery/
    └── dotfiles-workspace/
        └── main/           # Main branch checkout
```

### Repository Tracking

Repository information is stored in `~/Environment/repos.yml`:

```yaml
---
owners:
  kin:
    dot-com:
      default_branch: main
    rater-api:
      default_branch: main
  highwaybobbery:
    dotfiles:
      default_branch: master
```

## Environment Variables

The following environment variables are configured:

- `KIN_DIRECTORY` - Path to Kin projects directory (`~/Projects/kin`)
- `DEV_KIT_DIRECTORY` - Path to dev kit repository
- `PROJECTS_DIRECTORY` - Path to all projects (`~/Projects`)
- `REPOS_FILE` - Path to repository tracking file (`~/Environment/repos.yml`)

## Shell Aliases

Key aliases for development workflow:

```bash
# Project navigation
alias projects="cd ~/Projects"
alias kin="cd ~/Projects/kin"
alias dotcom="cd ~/Projects/kin/dot-com"
alias rater="cd ~/Projects/kin/rater-api"

# Development utilities
alias add_repo="~/Projects/highwaybobbery/dotfiles-workspace/main/scripts/add_repo.rb"
alias clone_project="~/Projects/highwaybobbery/dotfiles-workspace/main/scripts/clone_project.rb"
```

## Installation

### Method 1: Dotfiles Installation

Install dotfiles and shell configuration:

```bash
# Clone the repository
git clone git@github.com:highwaybobbery/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run installation script
./install.sh
```

This will:
- Install Oh My Zsh if not present
- Create symlinks for all dotfiles
- Set up configuration files in `~/.config/`

### Method 2: Dev Kit Installation (Legacy)

Install through the Kin dev kit system:

```bash
# Quick install
mkdir -p ~/Projects/kin/alex_berry_dev_tools-workspace && \
cd ~/Projects/kin/alex_berry_dev_tools-workspace && \
git clone git@github.com:kin/alex_berry_dev_tools.git main && \
cd main && \
./install.sh
```

This will:
- Create `~/Environment/repos.yml` if it doesn't exist
- Set up repository tracking system
- Create symlinks for configuration files
- Clone all tracked repositories

**Note:** These installation methods will be merged in a future update.

## Configuration Files

### Shell Configuration
- `zshrc` - Zsh shell configuration with custom functions and environment setup
- `aliases` - Custom shell aliases for development workflow

### Development Tools
- `vimrc` - Vim editor configuration
- `tmux.conf` - Terminal multiplexer configuration
- `gitconfig` - Git configuration and aliases

### Terminal
- `config/alacritty/alacritty.toml` - Alacritty terminal configuration
- `config/nvim/` - Neovim configuration with plugins and key bindings

## Usage

### Adding New Repositories

To add a new repository to your development environment:

```bash
add_repo owner/repo_name
```

This will:
1. Detect the repository's default branch
2. Add it to `~/Environment/repos.yml`
3. Optionally clone it into the workspace structure

### Cloning Repositories

To clone a repository into the workspace structure:

```bash
clone_project owner/repo_name
```

This creates the directory structure and clones the repository into the appropriate location.

### Development Workflow

1. **Add Repository**: `add_repo kin/new-project`
2. **Navigate**: `cd ~/Projects/kin/new-project-workspace/main`
3. **Develop**: Work on the project
4. **Switch Projects**: Use aliases like `dotcom` or `rater`

## Customization

### Adding New Aliases

Edit the `aliases` file and run:
```bash
source ~/.zshrc
```

### Modifying Environment Variables

Edit the `zshrc` file and reload your shell configuration.

### Adding New Scripts

Place new Ruby scripts in the `scripts/` directory and make them executable:
```bash
chmod +x scripts/new_script.rb
```

## Requirements

- Ruby (for development scripts)
- Git
- Zsh shell
- Oh My Zsh (installed automatically)

## Troubleshooting

### Permission Issues
Make sure scripts are executable:
```bash
chmod +x scripts/*.rb
```

### Environment Variables
If environment variables aren't set, source your shell configuration:
```bash
source ~/.zshrc
```

### Repository Tracking
Check `~/Environment/repos.yml` for repository configuration and ensure the file exists.