#!/usr/bin/env ruby

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
      puts "Usage: #{$0} <owner/repo_name>"
      exit 1
    end

    owner_repo = args.first
    owner, repo_name = parse_owner_repo(owner_repo)
    
    # Get default branch from repos.yml
    default_branch = get_default_branch(owner, repo_name)
    
    owner_dir = File.join(@projects_directory, owner)
    repo_dir = File.join(owner_dir, repo_name)
    trees_dir = File.join(repo_dir, "trees")
    default_dir = File.join(trees_dir, "default")

    # Create owner directory
    FileUtils.mkdir_p(owner_dir)

    # Clone the repository as bare
    git_url = "git@github.com:#{owner_repo}.git"
    stdout, stderr, status = Open3.capture3('git', 'clone', '--bare', git_url, repo_dir)

    if !status.success?
      puts "Error cloning #{owner_repo}:"
      puts stderr
      exit 1
    end

    # Create trees directory
    FileUtils.mkdir_p(trees_dir)

    # Add worktree for default branch
    Dir.chdir(repo_dir) do
      stdout, stderr, status = Open3.capture3('git', 'worktree', 'add', default_dir, default_branch)
      
      if status.success?
        puts "Successfully cloned #{owner_repo} as bare repository"
        puts "Created worktree for #{default_branch} at #{default_dir}"
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
      puts "Error: Invalid format. Use owner/repo_name"
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
if __FILE__ == $0
  ProjectCloner.new.run(ARGV)
end