ZDOTDIR="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"
DOTFILES_MACOS_ROOT="${DOTFILES_MACOS_ROOT:-${ZDOTDIR:h}}"

source "$DOTFILES_MACOS_ROOT/shell/portable.zsh"
source "$DOTFILES_MACOS_ROOT/shell/darwin.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/vi-mode.zsh"

if [[ -r "${ZSH_AUTOSUGGESTIONS_PATH:-}" ]]; then
  source "$ZSH_AUTOSUGGESTIONS_PATH"
fi

if [[ -r "${ZSH_SYNTAX_HIGHLIGHTING_PATH:-}" ]]; then
  source "$ZSH_SYNTAX_HIGHLIGHTING_PATH"
fi
