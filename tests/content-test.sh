#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "$root/tests/test-helper.sh"

test -f "$root/ghostty/config" || fail 'missing ghostty config'
assert_contains 'command = /bin/zsh' "$root/ghostty/config"

if rg -n 'BEGIN .*PRIVATE KEY|GH_TOKEN_OP_REF|1password|op run|/opt/cuda|LD_LIBRARY_PATH|startx|XAUTHORITY|OPAMROOT|/storage' \
  --glob '!docs/**' --glob '!tests/**' "$root"; then
  fail 'prohibited configuration found'
fi

printf 'content test: PASS\n'
