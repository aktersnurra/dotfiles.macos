#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "$root/tests/test-helper.sh"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/home/.config/zsh" "$work/home/.cache" "$work/home/.local/state"

HOME="$work/home" XDG_CONFIG_HOME="$work/home/.config" ZDOTDIR="$work/home/.config/zsh" \
  DOTFILES_MACOS_ROOT="$root" zsh -fc 'source "$DOTFILES_MACOS_ROOT/zsh/.zshrc"' \
  >"$work/out" 2>"$work/err"

printf 'shell test: PASS\n'
