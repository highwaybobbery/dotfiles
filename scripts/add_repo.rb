#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'open3'

class RepoManager
  def initialize
    @repos_file = File.expand_path("#{ENV['HOME']}/Environment/repos.yml")
    @projects_directory = File.expand_path("#{ENV['HOME']}/Projects")
    @dev_kit_directory = File.expand_path(ENV['DEV_KIT_DIRECTORY'])
  end

  def run(args)
    if args.empty?
      puts "Usage: #{$PROGRAM_NAME} <owner/repo_name> OR #{$PROGRAM_NAME} <full_git_url>"
      puts 'Examples:'
      puts "  #{$PROGRAM_NAME} kin/dot-com"
      puts "  #{$PROGRAM_NAME} git@github.com:kin/dot-com.git"
      exit 1
    end

    repo_input = args.first
    owner, repo_name, git_url = parse_repo_input(repo_input)

    puts "Finding default branch for #{owner}/#{repo_name}..."
    default_branch = get_default_branch(git_url)

    if default_branch.nil?
      puts "Error: Could not determine default branch for #{git_url}"
      exit 1
    end

    puts "Default branch for #{owner}/#{repo_name} is: #{default_branch}"

    repos_data = load_repos_file

    if repo_exists?(repos_data, owner, repo_name)
      handle_existing_repo(repos_data, owner, repo_name, default_branch)
    else
      add_new_repo(repos_data, owner, repo_name, default_branch)
    end

    alphabetize_repos(repos_data)
    save_repos_file(repos_data)

    prompt_for_clone(owner, repo_name, default_branch)
  end

  private

  def parse_repo_input(repo_input)
    if repo_input.include?('@')
      # Full git URL provided
      git_url = repo_input
      match = git_url.match(/github\.com:(.+)\.git$/)
      if match
        owner_repo = match[1]
        owner, repo_name = owner_repo.split('/')
      else
        puts 'Error: Invalid git URL format'
        exit 1
      end
    else
      # owner/repo format provided
      owner, repo_name = repo_input.split('/')
      if owner.nil? || repo_name.nil?
        puts 'Error: Invalid format. Use owner/repo_name'
        exit 1
      end
      git_url = "git@github.com:#{repo_input}.git"
    end

    [owner, repo_name, git_url]
  end

  def get_default_branch(git_url)
    stdout, _, status = Open3.capture3('git', 'ls-remote', '--symref', git_url, 'HEAD')

    return unless status.success?

    # Find the line with "ref: refs/heads/" and extract just the branch name
    ref_line = stdout.lines.find { |line| line.include?('ref: refs/heads/') }
    return unless ref_line

    ref_line.match(%r{ref: refs/heads/(.+?)\s})&.[](1)
  end

  def load_repos_file
    if File.exist?(@repos_file)
      YAML.load_file(@repos_file) || {}
    else
      {}
    end
  end

  def save_repos_file(repos_data)
    File.write(@repos_file, repos_data.to_yaml)
  end

  def repo_exists?(repos_data, owner, repo_name)
    repos_data.dig('owners', owner, repo_name)
  end

  def handle_existing_repo(repos_data, owner, repo_name, default_branch)
    puts "Repository #{owner}/#{repo_name} already exists in repos.yml"

    current_branch = repos_data.dig('owners', owner, repo_name, 'default_branch')

    if current_branch != default_branch
      puts "Default branch changed from #{current_branch} to #{default_branch}"

      # Update repos.yml
      repos_data['owners'][owner][repo_name]['default_branch'] = default_branch
      puts "Updated #{owner}/#{repo_name} with new default branch: #{default_branch}"

      # Check if workspace exists and update checkout
      handle_workspace_update(repo_name, current_branch, default_branch, owner)
    else
      puts "Default branch is already correct: #{default_branch}"
    end
  end

  def add_new_repo(repos_data, owner, repo_name, default_branch)
    repos_data['owners'] ||= {}
    repos_data['owners'][owner] ||= {}
    repos_data['owners'][owner][repo_name] = { 'default_branch' => default_branch }
    puts "Added #{owner}/#{repo_name} to repos.yml with default branch: #{default_branch}"
  end

  def handle_workspace_update(repo_name, current_branch, default_branch, owner)
    repo_dir = File.join(@projects_directory, owner, repo_name)
    current_branch_dir = File.join(repo_dir, current_branch)
    default_branch_dir = File.join(repo_dir, default_branch)

    return unless Dir.exist?(repo_dir)

    puts 'Updating worktree checkout...'

    if Dir.exist?(current_branch_dir)
      # Switch the worktree to the new default branch
      Dir.chdir(repo_dir) do
        # Remove old worktree
        system('git', 'worktree', 'remove', current_branch_dir)

        # Add new worktree for new default branch
        system('git', 'worktree', 'add', default_branch_dir, default_branch)
      end

      puts "Updated worktree from #{current_branch} to #{default_branch}"
    else
      puts "Current branch worktree directory doesn't exist"
    end
  end

  def alphabetize_repos(repos_data)
    puts 'Alphabetizing repos.yml...'

    return unless repos_data['owners']

    # Sort owners
    repos_data['owners'] = repos_data['owners'].sort.to_h

    # Sort repos within each owner
    repos_data['owners'].each do |owner, repos|
      repos_data['owners'][owner] = repos.sort.to_h
    end
  end

  def prompt_for_clone(owner, repo_name, default_branch)
    puts ''
    print "Do you want to clone #{owner}/#{repo_name} to #{@projects_directory}/#{owner}/#{repo_name}/#{default_branch}? (Y/N): "
    response = $stdin.gets.chomp

    if response.match?(/^[Yy]/)
      puts "Cloning #{owner}/#{repo_name}..."
      clone_script = File.join(File.dirname(__FILE__), 'clone_project.rb')
      system(clone_script, "#{owner}/#{repo_name}")
      puts 'Repository cloned successfully!'
    else
      puts 'Repository not cloned.'
      puts "To clone later, run: clone_project #{owner}/#{repo_name}"
    end
  end
end

# Run the script
RepoManager.new.run(ARGV) if __FILE__ == $PROGRAM_NAME
