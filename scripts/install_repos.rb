#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'
require 'stringio'
require_relative 'clone_project'

class RepoInstaller
  def initialize
    @repos_file = File.expand_path("#{ENV['HOME']}/Environment/repos.yml")
    @projects_directory = File.expand_path("#{ENV['HOME']}/Projects")
    @cloner = ProjectCloner.new
  end

  def run
    unless File.exist?(@repos_file)
      puts "Error: repos.yml not found at #{@repos_file}"
      puts "Please create the file or run the main install script first."
      exit 1
    end

    repos_data = YAML.load_file(@repos_file)
    
    unless repos_data && repos_data['owners']
      puts "Error: Invalid repos.yml format. Expected 'owners' key."
      exit 1
    end

    puts "Installing repositories from #{@repos_file}..."
    puts "Target directory: #{@projects_directory}"
    puts ""

    total_repos = count_total_repos(repos_data)
    current_repo = 0
    failed_repos = []

    repos_data['owners'].each do |owner, repos_hash|
      next unless repos_hash

      repos_hash.each do |repo_name, repo_config|
        current_repo += 1
        owner_repo = "#{owner}/#{repo_name}"
        
        puts "[#{current_repo}/#{total_repos}] Processing #{owner_repo}..."
        
        if repo_already_exists?(owner, repo_name, repo_config)
          puts "  ✓ Repository already exists, skipping"
        else
          begin
            puts "  → Cloning #{owner_repo}..."
            # Capture stdout/stderr to avoid messy output during errors
            original_stdout = $stdout
            original_stderr = $stderr
            
            # Create a temporary IO to capture output
            output_buffer = StringIO.new
            $stdout = output_buffer
            $stderr = output_buffer
            
            @cloner.run([owner_repo])
            
            # Restore stdout/stderr
            $stdout = original_stdout
            $stderr = original_stderr
            
            puts "  ✓ Successfully cloned #{owner_repo}"
          rescue SystemExit => e
            # Restore stdout/stderr
            $stdout = original_stdout
            $stderr = original_stderr
            
            if e.status != 0
              puts "  ✗ Failed to clone #{owner_repo} (repository may not exist or access denied)"
              failed_repos << owner_repo
            else
              puts "  ✓ Successfully cloned #{owner_repo}"
            end
          rescue => e
            # Restore stdout/stderr
            $stdout = original_stdout
            $stderr = original_stderr
            
            error_msg = "Failed to clone #{owner_repo}: #{e.message}"
            puts "  ✗ #{error_msg}"
            failed_repos << owner_repo
          end
        end
        
        puts ""
      end
    end

    print_summary(total_repos, current_repo, failed_repos)
  end

  private

  def count_total_repos(repos_data)
    count = 0
    repos_data['owners'].each do |owner, repos_hash|
      count += repos_hash.size if repos_hash
    end
    count
  end

  def repo_already_exists?(owner, repo_name, repo_config)
    default_branch = repo_config['default_branch'] || 'main'
    repo_dir = File.join(@projects_directory, owner, repo_name)
    branch_dir = File.join(repo_dir, default_branch)
    
    # Check if both the bare repo and the worktree exist
    File.directory?(repo_dir) && File.directory?(branch_dir)
  end

  def print_summary(total_repos, processed_repos, failed_repos)
    puts "=" * 60
    puts "REPOSITORY INSTALLATION SUMMARY"
    puts "=" * 60
    puts "Total repositories: #{total_repos}"
    puts "Processed: #{processed_repos}"
    
    if failed_repos.empty?
      puts "All repositories processed successfully! ✓"
    else
      puts "Failed repositories: #{failed_repos.size}"
      puts ""
      puts "Failed to clone:"
      failed_repos.each do |repo|
        puts "  - #{repo}"
      end
      puts ""
      puts "You can manually retry failed repositories with:"
      puts "  ./scripts/clone_project.rb <owner/repo_name>"
    end
    
    puts ""
    puts "Repository locations:"
    puts "  ~/Projects/{owner}/{repo_name}/{default_branch}/"
    puts ""
  end
end

# Allow the script to be run directly or required as a library
if __FILE__ == $0
  RepoInstaller.new.run
end