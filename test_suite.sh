#!/bin/sh

RED='\033[1;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
RESET='\033[0m'

set -e

nb=0
# Function to run a test command and check its success
test_cmd() {
  echo -e "$WHITE[TESTING] $@"
  if ./test.sh "$@"; then
    echo "$GREEN[PASSED]"
  else
    echo "$RED[FAILED]"
    exit 1
  fi
  nb=$((nb + 1))
}

# Test valid commands
test_cmd
test_cmd -a
test_cmd -a -a
test_cmd git
test_cmd nvim
test_cmd -a nvim bidule
test_cmd -a ok ok
test_cmd -a nvim git
test_cmd nvim bidule
test_cmd ok ok
test_cmd nvim git

# Test invalid commands (expected to fail)
test_cmd invalid_arg
test_cmd -invalid
test_cmd git invalid_arg
test_cmd nvim -invalid
test_cmd -a invalid_arg
test_cmd -a -invalid

# Edge cases
test_cmd ""  # Empty argument
test_cmd " " # Space as argument
test_cmd "multiple words" # Argument with spaces
test_cmd "!@#$%^&*()"
test_cmd \"
test_cmd "test_with_underscores"
test_cmd "test-with-hyphens"
test_cmd

echo "\n${WHITE}All tests passed !\n$RESET"
