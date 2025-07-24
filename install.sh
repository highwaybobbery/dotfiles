#!/bin/bash

# =============================================================================
# DOTFILES INSTALLATION SECTION
# =============================================================================
# This section handles the original dotfiles functionality:
# - Installs Oh My Zsh if not present
# - Creates symlinks for dotfiles in home directory
# - Creates symlinks for config files in ~/.config/

echo "Starting dotfiles installation..."

# Install Oh My Zsh if not already installed
if [[ ! $ZSH ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed"
fi

# Create symlinks for dotfiles in home directory
echo "Creating dotfile symlinks..."
for name in *; do
  ignored=("install.sh" "uninstall.sh" "README.md" "scripts")
  if [[ ! $ignored =~ $name ]] && [[ ! -d $name ]]; then
    target="$HOME/.$name"
    if [ -e "$target" ]; then
      if [ ! -L "$target" ]; then
        echo "WARNING: $target exists but is not a symlink."
      else
        echo "Already Linked $target"
      fi
    else
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

# Create symlinks for config files in ~/.config/
echo "Creating config symlinks..."
cd config

for name in *; do
  target="$HOME/.config/$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      echo "WARNING: $target exists but is not a symlink."
    else
      echo "Already Linked $target"
    fi
  else
    echo "Creating $target"
    ln -s "$PWD/$name" "$target"
  fi
done

# Create Claude configuration symlink
echo "Setting up Claude configuration..."
if [ ! -d "$HOME/.claude" ]; then
    mkdir -p "$HOME/.claude"
fi

target="$HOME/.claude/CLAUDE.md"
source="$PWD/claude_config/CLAUDE.md"
if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
        echo "WARNING: $target exists but is not a symlink."
    else
        echo "Already Linked $target"
    fi
else
    echo "Creating $target"
    ln -s "$source" "$target"
fi

cd ..

# Create ~/.claude/commands directory and symlink command files
echo "Setting up Claude Code commands..."
mkdir -p "$HOME/.claude/commands"

for command_file in "$PWD/commands"/*.md; do
    if [ -f "$command_file" ]; then
        command_name=$(basename "$command_file")
        target_link="$HOME/.claude/commands/$command_name"
        
        if [ -L "$target_link" ]; then
            echo "Command $command_name symlink already exists"
        else
            echo "Creating symlink for command: $command_name"
            ln -sf "$command_file" "$target_link"
        fi
    fi
done

echo "Dotfiles installation complete!"

# =============================================================================
# DEVELOPMENT ENVIRONMENT SETUP SECTION
# =============================================================================
# This section handles development environment setup:
# - Creates Environment directory and repos.yml
# - Sets up repository tracking system
# - Clones tracked repositories into workspace structure

echo ""
echo "Starting development environment setup..."

# Ensure Environment directory exists for storing repos.yml
if [ ! -d "$HOME/Environment" ]; then
    echo "Creating Environment directory..."
    mkdir -p "$HOME/Environment"
else
    echo "Environment directory already exists"
fi

# Create repos.yml if it doesn't exist
if [ ! -f "$HOME/Environment/repos.yml" ]; then
    echo "Creating initial repos.yml file..."
    cat > "$HOME/Environment/repos.yml" << 'EOF'
---
owners:
EOF
    echo "Created $HOME/Environment/repos.yml"
else
    echo "repos.yml already exists"
fi

# Set up repository workspaces based on repos.yml
echo "Setting up repository workspaces..."

# Clone all repositories from repos.yml
if [ -f "$HOME/Environment/repos.yml" ]; then
    echo "Processing repositories from repos.yml..."
    "$PWD/scripts/install_repos.rb"
else
    echo "repos.yml not found, skipping repository setup"
fi

echo ""
echo "Development environment setup complete!"
echo ""
echo "============================================================================="
echo ""
echo "INSTALLATION SUMMARY:"
echo "- Dotfiles symlinked to home directory"
echo "- Config files symlinked to ~/.config/"
echo "- Environment directory created at ~/Environment/"
echo "- Repository tracking system initialized"
echo "- All tracked repositories cloned to ~/Projects/{owner}/{repo}/{default_branch}/"
echo ""
echo "To add new repositories: ./scripts/add_repo.rb owner/repo_name"
echo "To clone repositories: ./scripts/clone_project.rb owner/repo_name"
echo "To install all repositories: ./scripts/install_repos.rb"
echo ""
echo "Restart your terminal or run 'source ~/.zshrc' to use new configuration."
