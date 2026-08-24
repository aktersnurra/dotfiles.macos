#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "$root/tests/test-helper.sh"

files=("$root/shell"/*.zsh "$root/zsh"/*.zsh)

for file in "${files[@]}"; do
  test -f "$file" || fail "missing shell file"
done

if rg -n '^[[:space:]]*git clone|/home/|PATH="/opt/|startx|XAUTHORITY|OPAMROOT|CUDA|LD_LIBRARY_PATH|OLLAMA_MODELS|HF_HOME' "${files[@]}"; then
  fail 'non-portable shell behavior found'
fi

if rg -n 'source "\$\{ZSH_(AUTOSUGGESTIONS|SYNTAX_HIGHLIGHTING)_PATH:-\}"' "$root/zsh/.zshrc"; then
  fail 'plugin source path lacks readability guard'
fi

printf 'adoption test: PASS\n'
