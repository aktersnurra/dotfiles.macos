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

DOTFILES_MACOS_ROOT="$root" zsh -fc '
  bindkey() {
    if [[ "$1" == "-lL" ]]; then
      return 0
    fi
    if [[ "$1" == "-M" && "$2" == "menuselect" ]]; then
      print -u2 "no such keymap: $2"
      return 1
    fi
    builtin bindkey "$@"
  }
  zle() { :; }
  source "$DOTFILES_MACOS_ROOT/zsh/vi-mode.zsh"
' >"$work/vi-mode-out" 2>"$work/vi-mode-err"

assert_not_contains 'no such keymap' "$work/vi-mode-err"

printf 'shell test: PASS\n'
