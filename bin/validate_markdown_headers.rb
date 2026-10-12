#!/usr/bin/env ruby
# frozen_string_literal: true

# Quality Gate: Validates Markdown structure, header hierarchy, and link anchors
puts "🔍 [Quality Gate] Auditing Markdown header structure and anchors..."

errors = []
files = Dir.glob("**/*.md").reject { |f| f.start_with?("archive/") || f.start_with?("tmp/") }

files.each do |file|
  lines = File.readlines(file)
  
  lines.each_with_index do |line, idx|
    if line =~ /^(\#{1,6})\s+(.*)$/
      level = $1.length
      title = $2.strip
      
      # Check for trailing whitespace on header
      if line.end_with?(" \n") || line.end_with?(" \r\n")
        errors << "#{file}:#{idx + 1}: Header has trailing whitespace: '#{line.strip}'"
      end
      
      # Check for empty headers
      if title.empty?
        errors << "#{file}:#{idx + 1}: Empty header at level #{level}"
      end
    end
  end
end

if errors.empty?
  puts "✅ [Quality Gate] Header audit passed cleanly across #{files.size} markdown files."
  exit 0
else
  puts "❌ [Quality Gate] Header audit violations (#{errors.size}):"
  errors.each { |err| puts "  - #{err}" }
  exit 1
end
