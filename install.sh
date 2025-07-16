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

cd ..

echo "Dotfiles installation complete!"

# =============================================================================
# DEVELOPMENT ENVIRONMENT SETUP SECTION
# =============================================================================
# This section handles development environment setup:
# - Checks for Ruby availability
# - Creates Environment directory and repos.yml
# - Sets up repository tracking system
# - Clones tracked repositories into workspace structure

echo ""
echo "Starting development environment setup..."

# Check if Ruby is available (required for repository management scripts)
if ! command -v ruby &> /dev/null; then
    echo "Ruby is required for repository management but is not installed."
    echo "Please install Ruby and try again."
    echo "Skipping repository setup..."
    exit 0
else
    echo "Ruby is available"
fi

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
  kin:
  highwaybobbery:
EOF
    echo "Created $HOME/Environment/repos.yml"
else
    echo "repos.yml already exists"
fi

# Set up repository workspaces based on repos.yml
echo "Setting up repository workspaces..."

# Parse repos.yml and clone each repository using Ruby script
if [ -f "$HOME/Environment/repos.yml" ]; then
    echo "Processing repositories from repos.yml..."
    
    # Use Ruby to parse YAML and extract repository list
    ruby -e "
        require 'yaml'
        
        repos_file = File.expand_path('~/Environment/repos.yml')
        if File.exist?(repos_file)
            repos = YAML.load_file(repos_file)
            if repos && repos['owners']
                repos['owners'].each do |owner, repos_hash|
                    next unless repos_hash
                    repos_hash.each do |repo_name, _|
                        puts \"#{owner}/#{repo_name}\"
                    end
                end
            end
        end
    " | while read owner_repo; do
        if [ -n "$owner_repo" ]; then
            owner=$(echo "$owner_repo" | cut -d'/' -f1)
            repo_name=$(echo "$owner_repo" | cut -d'/' -f2)
            echo "Checking workspace for $owner_repo..."
            
            # Check if repository already exists
            if [ ! -d "${HOME}/Projects/${owner}/${repo_name}/trees/default" ]; then
                echo "Setting up repository for $owner_repo..."
                "$PWD/scripts/clone_project.rb" "$owner_repo" || echo "Failed to clone $owner_repo (may not exist yet)"
            else
                echo "Repository for $owner_repo already exists"
            fi
        fi
    done
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
echo "- All tracked repositories cloned to ~/Projects/{owner}/{repo}/trees/default/"
echo ""
echo "To add new repositories: ./scripts/add_repo.rb owner/repo_name"
echo "To clone repositories: ./scripts/clone_project.rb owner/repo_name"
echo ""
echo "Restart your terminal or run 'source ~/.zshrc' to use new configuration."