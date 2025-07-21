#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'yaml'

class ProjectCloner
  def initialize
    @projects_directory = File.expand_path("#{ENV['HOME']}/Projects")
    @repos_file = File.expand_path("#{ENV['HOME']}/Environment/repos.yml")
  end

  def run(args)
    if args.empty?
      puts "Usage: #{$PROGRAM_NAME} <owner/repo_name>"
      exit 1
    end

    owner_repo = args.first
    owner, repo_name = parse_owner_repo(owner_repo)

    # Get default branch from repos.yml
    default_branch = get_default_branch(owner, repo_name)

    owner_dir = File.join(@projects_directory, owner)
    repo_dir = File.join(owner_dir, repo_name)
    branch_dir = File.join(repo_dir, default_branch)

    # Create owner directory
    FileUtils.mkdir_p(owner_dir)

    # Clone the repository as bare
    git_url = "git@github.com:#{owner_repo}.git"
    stdout, stderr, status = Open3.capture3('git', 'clone', '--bare', git_url, repo_dir)

    unless status.success?
      puts "Error cloning #{owner_repo}:"
      puts stderr
      exit 1
    end

    # Set up proper remote fetch configuration
    Dir.chdir(repo_dir) do
      stdout, stderr, status = Open3.capture3('git', 'config', 'remote.origin.fetch', '+refs/heads/*:refs/remotes/origin/*')
      
      unless status.success?
        puts "Warning: Could not set up remote fetch configuration:"
        puts stderr
      end
    end

    # Add worktree for default branch
    Dir.chdir(repo_dir) do
      stdout, stderr, status = Open3.capture3('git', 'worktree', 'add', branch_dir, default_branch)

      if status.success?
        puts "Successfully cloned #{owner_repo} as bare repository"
        puts "Created worktree for #{default_branch} at #{branch_dir}"
        puts "Remote fetch configuration set up for proper branch tracking"
      else
        puts "Error creating worktree for #{default_branch}:"
        puts stderr
        exit 1
      end
    end
  end

  private

  def parse_owner_repo(owner_repo)
    parts = owner_repo.split('/')
    if parts.length != 2
      puts 'Error: Invalid format. Use owner/repo_name'
      exit 1
    end
    parts
  end

  def get_default_branch(owner, repo_name)
    if File.exist?(@repos_file)
      repos_data = YAML.load_file(@repos_file)
      default_branch = repos_data.dig('owners', owner, repo_name, 'default_branch')
      return default_branch if default_branch
    end

    # Fallback to 'main' if not found in repos.yml
    'main'
  end
end

# Run the script
ProjectCloner.new.run(ARGV) if __FILE__ == $PROGRAM_NAME
