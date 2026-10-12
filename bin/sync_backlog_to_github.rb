#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "json"

TASKS_DIR = File.expand_path("../backlog/tasks", __dir__)

existing_issues = JSON.parse(`gh issue list --limit 100 --json number,title`) rescue []
existing_titles = existing_issues.map { |i| [i["title"], i["number"]] }.to_h

Dir.glob("#{TASKS_DIR}/*.md").sort.each do |task_file|
  content = File.read(task_file)
  
  if content =~ /\A---\s*\n(.*?)\n---\s*\n(.*)\z/m
    frontmatter = YAML.safe_load($1) rescue {}
    body = $2.strip
  else
    next
  end

  title = frontmatter["title"] || File.basename(task_file, ".md")
  task_id = frontmatter["id"] || File.basename(task_file, ".md")
  full_title = "[#{task_id}] #{title}"

  if existing_titles[full_title]
    puts "✅ Issue already exists: #{full_title} (##{existing_titles[full_title]})"
    next
  end

  issue_body = <<~BODY
    #{body}

    ---
    - **Backlog.md Task ID**: `#{task_id}`
    - **Priority**: `#{frontmatter["priority"] || "Medium"}`
    - **Type**: `#{frontmatter["type"] || "task"}`
    - **Status**: `#{frontmatter["status"] || "To Do"}`
    - **Source File**: `backlog/tasks/#{File.basename(task_file)}`
  BODY

  puts "✨ Creating GitHub Issue for #{full_title}..."
  system("gh", "issue", "create", "--title", full_title, "--body", issue_body)
end

puts "✅ All Backlog.md tasks synchronized to GitHub Issues."
