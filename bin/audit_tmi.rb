#!/usr/bin/env ruby
# frozen_string_literal: true

require "find"

GUARDS = [
  { id: :pii_home_path, pattern: /\/Users\/[a-zA-Z0-9_-]+/, note: "Hardcoded absolute user home path found; use ~ or relative alias" },
  { id: :pii_phone, pattern: /(?<![\/\w])(\+?1[\s.-]?)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}(?!\d)/, note: "Phone number pattern" },
  { id: :pii_email, pattern: /\b[a-zA-Z0-9._%+-]+@(?!just3ws\.com|wwworkremote\.com)[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b/, note: "Personal email address" },
  { id: :pii_address, pattern: /\b\d{3,5}\s+[A-Z][a-z]+\s+(St|Ave|Blvd|Dr|Rd|Ln|Way|Ct|Pl)\b/, note: "Street address pattern" },
  { id: :pii_gps, pattern: /\b-?\d{1,3}\.\d{4,},\s*-?\d{1,3}\.\d{4,}\b/, note: "Precise GPS coordinates" },
  { id: :pii_family, pattern: /\b(my (wife|husband|spouse|partner|son|daughter|child|kid|mom|dad))\s+([A-Z][a-z]+)\b/, note: "Family member name disclosure" },
  { id: :phi_diagnosis, pattern: /\b(ADHD|autism|autistic|AuDHD|dyslexia|dyslexic|bipolar|depression|anxiety disorder|OCD|PTSD|BPD)\b/, note: "Named medical/clinical diagnosis" },
  { id: :phi_treatment, pattern: /\b(my therapist|in therapy|hospitaliz|medication|prescription|diagnosed with)\b/i, note: "Clinical treatment disclosure" },
  { id: :tmi_relationship, pattern: /\b(when I was (married|divorced|single)|my ex[\s-]?(wife|husband|partner)|my (divorce|separation|breakup))\b/i, note: "Relationship status detail" },
  { id: :tmi_distress, pattern: /\b(I was (broke|unemployed|laid off|let go|fired)|couldn.t afford|my debt|student loans?)\b/i, note: "Financial distress signal" },
  { id: :tmi_burnout, pattern: /\b(burned out|breaking point|mental breakdown|rock bottom|nervous breakdown)\b/i, note: "Burnout / breakdown signal" }
].freeze

files = Dir.glob("**/*.{md,html,txt,sh,py}").reject { |f| f.start_with?("archive/") || f.start_with?("tmp/") }

violations = []
files.each do |file|
  lines = File.readlines(file)
  lines.each_with_index do |line, idx|
    GUARDS.each do |guard|
      if line.match?(guard[:pattern])
        violations << { file: file, line_num: idx + 1, guard: guard[:id], note: guard[:note], text: line.strip }
      end
    end
  end
end

if violations.empty?
  puts "✅ [TMI Guard] All #{files.size} public files passed cleanly (0 PII / PHI / TMI findings)."
  exit 0
else
  puts "⚠️ [TMI Guard] Found #{violations.size} potential findings:"
  violations.each do |v|
    puts "  - #{v[:file]}:#{v[:line_num]} [#{v[:guard]}] #{v[:note]}: #{v[:text][0..80]}"
  end
  exit 1
end
