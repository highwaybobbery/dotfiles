# Repository Management Scripts

This dotfiles repository includes a comprehensive system for managing Git repositories using a bare repository + worktree approach. All repositories are managed centrally through `~/Environment/repos.yml`.

## Quick Start

**Most common workflow:** Use `add_repo.rb` first - it's your entry point for new repositories.

```bash
add_repo.rb owner/repo_name
# Example: add_repo.rb kin/dot-com
```

## The Four Scripts

### 1. `add_repo.rb` - 🌟 **START HERE**

**Purpose:** Register a new repository and optionally clone it immediately.

**What it does:**
- Queries the remote repository to find the actual default branch (main vs master)  
- Adds the repository to your centralized `~/Environment/repos.yml` configuration
- If the repo already exists but the default branch changed, updates worktrees accordingly
- Prompts to automatically clone the repository (runs `clone_project.rb`)
- Keeps repos.yml alphabetized

**Usage:**
```bash
add_repo.rb owner/repo_name
add_repo.rb git@github.com:owner/repo_name.git
```

**When to use:** Every time you want to start working with a new repository. This is your entry point.

### 2. `clone_project.rb` - The Actual Cloner

**Purpose:** Clone a repository as a bare repo with worktree for the default branch.

**What it does:**
- Looks up the default branch from `repos.yml` (fallback to 'main')
- Clones as a bare repository to `~/Projects/{owner}/{repo_name}/`
- Sets up proper remote fetch configuration for branch tracking
- Creates initial worktree at `~/Projects/{owner}/{repo_name}/{default_branch}/`

**Usage:**
```bash
clone_project.rb owner/repo_name
```

**When to use:** 
- Automatically called by `add_repo.rb` if you choose to clone
- Manually when you want to clone a repo that's already in `repos.yml`
- When you need to re-clone a repository

### 3. `install_repos.rb` - Bulk Setup

**Purpose:** Clone all repositories listed in `repos.yml` that aren't already cloned.

**What it does:**
- Processes every repository in your `repos.yml` file
- Skips repositories that already exist locally
- Shows progress tracking and error reporting
- Provides a summary of successful and failed clones

**Usage:**
```bash
install_repos.rb
```

**When to use:**
- Setting up a new development machine
- After updating `repos.yml` with many new repositories
- Ensuring all your configured repositories are locally available

### 4. `fix_bare_repos.rb` - Maintenance Tool

**Purpose:** Fix remote fetch configuration for existing bare repositories.

**What it does:**
- Updates git configuration for proper branch tracking
- Can work from `repos.yml` or scan directories manually
- Fixes repositories that were cloned before proper setup was implemented

**Usage:**
```bash
fix_bare_repos.rb
```

**When to use:**
- After system updates or git configuration changes
- When branch tracking isn't working properly
- One-time fix for repositories cloned with older versions of the scripts

## Typical Workflows

### Working with a new repository
```bash
# 1. Register and clone (this is usually all you need)
add_repo.rb owner/repo_name

# The script will ask if you want to clone - say yes!
```

### Setting up a new machine
```bash
# 1. Ensure your repos.yml is in place
# 2. Clone all configured repositories
install_repos.rb
```

### Fixing configuration issues
```bash
# Fix all bare repositories
fix_bare_repos.rb
```

## Directory Structure

Repositories are organized as:
```
~/Projects/
├── owner1/
│   ├── repo1/              # Bare git repository
│   │   ├── main/           # Worktree for main branch
│   │   └── feature-branch/ # Additional worktrees as needed
│   └── repo2/
│       └── main/
└── owner2/
    └── repo3/
        └── main/
```

## Configuration File

The central configuration is stored at `~/Environment/repos.yml`:

```yaml
owners:
  owner1:
    repo1:
      default_branch: main
    repo2:
      default_branch: master
  owner2:
    repo3:
      default_branch: main
```

This file is automatically managed by the scripts and kept alphabetized.