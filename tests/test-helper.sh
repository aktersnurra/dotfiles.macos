#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  grep -Fq -- "$1" "$2" || fail "missing $1"
}

assert_not_contains() {
  if grep -Fq -- "$1" "$2"; then
    fail "unexpected $1"
  fi
}
