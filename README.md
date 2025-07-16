# Alex Berry Dotfiles & Development Tools

Personal dotfiles and development toolkit for working across multiple code repositories and organizations.

## Overview

This repository contains:
- **Dotfiles**: Shell configuration, aliases, and environment setup
- **Development Scripts**: Ruby utilities for repository management and project setup
- **Configuration Files**: Git, Vim, Tmux, Neovim, and terminal configurations
- **Theme Management**: Centralized theme switching for development environment

## Directory Structure

```
.
├── scripts/              # Ruby development utilities
│   ├── add_repo.rb      # Add repositories to tracking system
│   ├── clone_project.rb # Clone repositories into bare repo structure
│   ├── install_repos.rb # Install all repositories from repos.yml
│   └── theme-switcher   # Theme switching for Alacritty, tmux, Neovim
├── bin/                 # Symlinked executables
│   └── theme-switcher   # Theme switcher symlink
├── config/              # Configuration files for various tools
│   ├── alacritty/       # Terminal emulator configuration
│   │   ├── alacritty.toml
│   │   ├── catppuccin-latte.toml
│   │   └── catppuccin-mocha.toml
│   ├── nvim/            # Neovim configuration
│   │   ├── init.lua
│   │   └── lua/
│   └── tmux/            # Tmux themes
│       └── themes/
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
Clones repositories as bare repos with worktrees based on their default branch.

**Usage:**
```bash
./scripts/clone_project.rb <owner/repo_name>
```

**Example:**
```bash
./scripts/clone_project.rb kin/dot-com
```

This creates a bare repository with a worktree for the default branch.

#### install_repos.rb
Installs all repositories defined in `~/Environment/repos.yml`.

**Usage:**
```bash
./scripts/install_repos.rb
```

This script reads the repository configuration and clones all tracked repositories.

### Theme Management

#### theme-switcher
Centralized theme switching for Alacritty, tmux, and Neovim.

**Usage:**
```bash
./scripts/theme-switcher [light|dark]
```

**Examples:**
```bash
./scripts/theme-switcher light   # Switch to light theme
./scripts/theme-switcher dark    # Switch to dark theme
```

This script:
- Updates Alacritty to use Catppuccin Latte (light) or Mocha (dark)
- Updates tmux themes and powerline configuration
- Updates Neovim Catppuccin plugin flavour
- Reloads configurations automatically
- Plays notification sound when complete

### Workspace Structure

All projects follow a consistent bare repository structure organized by owner:

```
~/Projects/
├── kin/
│   ├── dot-com/            # Bare repository
│   │   ├── main/           # Main branch worktree
│   │   └── [feature-branches]/ # Feature branch worktrees
│   ├── administered-policies/
│   │   ├── main/           # Main branch worktree
│   │   └── PAP-175-add-underwriting-cancellation-restrictions/
│   └── rater-api/
│       └── main/           # Main branch worktree
└── highwaybobbery/
    └── dotfiles/           # Bare repository
        └── master/         # Master branch worktree
```

This structure uses git bare repositories with worktrees, allowing:
- Multiple branches to be checked out simultaneously
- Isolated working directories for each branch
- Efficient disk usage and faster branch switching

### Repository Tracking

Repository information is stored in `~/Environment/repos.yml`:

```yaml
---
owners:
  kin:
    dot-com:
      default_branch: main
    administered-policies:
      default_branch: main
    rater-api:
      default_branch: main
    accounting_system:
      default_branch: master
  highwaybobbery:
    dotfiles:
      default_branch: master
```

## Environment Directory

The `~/Environment/` directory contains configuration and data files:

```
~/Environment/
├── local_dotfiles/          # Local configuration overrides
│   ├── .aliases.local       # Custom aliases
│   ├── .gitconfig.local     # Git configuration overrides
│   └── .zshrc.local         # Zsh configuration overrides
├── repos.yml                # Repository tracking configuration
└── alacritty-theme/         # Alacritty theme collection
    ├── themes/              # Theme files
    └── images/              # Theme preview images
```

### Local Configuration Files

The `~/Environment/local_dotfiles/` directory contains environment-specific configuration:

- **`.aliases.local`**: Custom aliases for navigation and utilities
- **`.gitconfig.local`**: Git configuration overrides (user info, etc.)
- **`.zshrc.local`**: Zsh configuration overrides (environment variables, etc.)

These files are sourced by the main dotfiles and provide a way to customize the environment without modifying the main dotfiles repository.

## Environment Variables

The following environment variables are configured:

- `KIN_DIRECTORY` - Path to Kin projects directory (`~/Projects/kin`)
- `DEV_KIT_DIRECTORY` - Path to dev kit repository
- `PROJECTS_DIRECTORY` - Path to all projects (`~/Projects`)
- `REPOS_FILE` - Path to repository tracking file (`~/Environment/repos.yml`)
- `ENVIRONMENT_DIRECTORY` - Path to environment configuration (`~/Environment`)

## Shell Aliases

Key aliases for development workflow:

### Navigation Aliases
```bash
# Project navigation
alias projects="cd ~/Projects"
alias kin="cd ~/Projects/kin"
alias dotcom="cd ~/Projects/kin/dot-com/main"
alias rater="cd ~/Projects/kin/rater-api/main"

# Development utilities
alias add_repo="~/Projects/highwaybobbery/dotfiles/master/scripts/add_repo.rb"
alias clone_project="~/Projects/highwaybobbery/dotfiles/master/scripts/clone_project.rb"
```

### Standard Aliases
```bash
# Basic navigation
alias v="nvim"
alias p="cd ~/Projects/"
alias dotfiles="cd ~/Projects/highwaybobbery/dotfiles/master"

# Git shortcuts
alias g="git"
alias gs="git status"
alias gco="git checkout"

# Rails/Ruby development
alias spec="bundle exec rspec -fd"
alias brake="bundle exec rake"

# Tmux utilities
alias tmru="tmux resize-pane -U"
alias tmrd="tmux resize-pane -D"
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
3. Optionally clone it as a bare repository with worktree

### Cloning Repositories

To clone a repository into the bare repository structure:

```bash
clone_project owner/repo_name
```

This creates a bare repository with a worktree for the default branch.

### Installing All Repositories

To install all repositories from your configuration:

```bash
install_repos
```

This reads `~/Environment/repos.yml` and clones all tracked repositories.

### Theme Management

Switch between light and dark themes:

```bash
theme-switcher light    # Switch to light theme
theme-switcher dark     # Switch to dark theme
```

### Development Workflow

1. **Add Repository**: `add_repo kin/new-project`
2. **Navigate**: `cd ~/Projects/kin/new-project/main`
3. **Create Feature Branch**: Use git worktree or your preferred branching tool
4. **Develop**: Work on the project
5. **Switch Projects**: Use aliases like `dotcom` or `rater`
6. **Theme Switching**: Use `theme-switcher` to adjust environment

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
- Alacritty terminal emulator (for theme switching)
- Tmux (for terminal multiplexing and theme switching)
- Neovim (for theme switching)

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