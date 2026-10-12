#!/usr/bin/env bash
# bin/test_fix_video.sh: Automated Unit and Boundary Verification Suite for fix_video.sh
set -euo pipefail

PASS=0
FAIL=0

assert_success() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "  [PASS] $desc"
    PASS=$((PASS + 1))
  else
    echo "  [FAIL] $desc"
    FAIL=$((FAIL + 1))
  fi
}

assert_failure() {
  local desc="$1"
  shift
  if ! "$@" >/dev/null 2>&1; then
    echo "  [PASS] $desc"
    PASS=$((PASS + 1))
  else
    echo "  [FAIL] $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Running Sovereign CLI Verification Test Harness ==="

# Test 1: Syntax check
assert_success "Bash syntax validation" bash -n fix_video.sh

# Test 2: Help flag exits with 0
assert_success "Help option (--help)" ./fix_video.sh --help
assert_success "Help option short (-h)" ./fix_video.sh -h

# Test 3: Version flag exits with 0
assert_success "Version option (--version)" ./fix_video.sh --version
assert_success "Version option short (-v)" ./fix_video.sh -v

# Test 4: Missing arguments exit with error
assert_failure "Missing argument error handling" ./fix_video.sh

# Test 5: Non-existent file exits with error
assert_failure "Non-existent file handling" ./fix_video.sh /path/to/definitely_missing_file_xyz.mp4

# Test 6: Python transcript diff tool help
assert_success "Transcript diff tool syntax" python3 compare_transcripts.py --help

# Test 7: TMI Guard passes cleanly
assert_success "TMI/PII Guard validation" ruby bin/audit_tmi.rb

# Test 8: Markdown Header quality gate passes cleanly
assert_success "Markdown Header quality gate" ruby bin/validate_markdown_headers.rb

# Test 9: ShellCheck quality gate passes cleanly
assert_success "ShellCheck quality gate" ./bin/validate_shellcheck.sh

echo "========================================================="
echo "Summary: $PASS passed, $FAIL failed."
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
