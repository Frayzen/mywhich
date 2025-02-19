#!/bin/sh

set -e

test_cmd()
{
  echo "[TESTING] $@"
  ./test.sh "$@"
}

test_cmd git
test_cmd nvim
test_cmd -a nvim bidule
test_cmd -a ok ok
test_cmd -a nvim git
test_cmd nvim bidule
test_cmd ok ok
test_cmd nvim git
# test_cmd

echo "All test passed !"
