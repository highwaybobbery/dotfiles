#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'yaml'

class BareRepoFixer
  def initialize
    @projects_directory = File.expand_path("#{ENV['HOME']}/Projects")
    @repos_file = File.expand_path("#{ENV['HOME']}/Environment/repos.yml")
  end

  def run
    puts 'Fixing remote fetch configuration for all bare repositories...'
    puts '=' * 60
    puts

    if File.exist?(@repos_file)
      repos_data = YAML.load_file(@repos_file)
      fix_repos_from_config(repos_data)
    else
      puts "No repos.yml file found at #{@repos_file}"
      puts 'Scanning for bare repositories manually...'
      scan_and_fix_bare_repos
    end

    puts
    puts 'All bare repositories have been updated!'
    puts 'Remote fetch configuration set up for proper branch tracking.'
  end

  private

  def fix_repos_from_config(repos_data)
    repos_data['owners'].each do |owner, repos_hash|
      repos_hash.each do |repo_name, _repo_config|
        repo_dir = File.join(@projects_directory, owner, repo_name)
        fix_repo_if_bare(repo_dir, "#{owner}/#{repo_name}")
      end
    end
  end

  def scan_and_fix_bare_repos
    return unless Dir.exist?(@projects_directory)

    Dir.glob(File.join(@projects_directory, '*', '*')).each do |repo_dir|
      next unless Dir.exist?(repo_dir)

      owner = File.basename(File.dirname(repo_dir))
      repo_name = File.basename(repo_dir)
      repo_identifier = "#{owner}/#{repo_name}"

      fix_repo_if_bare(repo_dir, repo_identifier)
    end
  end

  def fix_repo_if_bare(repo_dir, repo_identifier)
    return unless Dir.exist?(repo_dir)

    # Check if this is a bare repository
    bare_check = File.join(repo_dir, 'HEAD')
    config_check = File.join(repo_dir, 'config')

    return unless File.exist?(bare_check) && File.exist?(config_check)

    # Check if it's actually bare (no working directory)
    return if File.exist?(File.join(repo_dir, '.git'))

    print "Fixing #{repo_identifier}... "

    Dir.chdir(repo_dir) do
      # Set up proper remote fetch configuration
      stdout, stderr, status = Open3.capture3('git', 'config', 'remote.origin.fetch', '+refs/heads/*:refs/remotes/origin/*')

      if status.success?
        puts '✓ Fixed'
      else
        puts '✗ Failed'
        puts "  Error: #{stderr.strip}" unless stderr.empty?
      end
    end
  rescue StandardError => e
    puts "✗ Error: #{e.message}"
  end
end

# Run the script
BareRepoFixer.new.run if __FILE__ == $PROGRAM_NAME