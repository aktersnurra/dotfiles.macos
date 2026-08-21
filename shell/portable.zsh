export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
export GPG_TTY="$(tty)"

setopt autocd extendedglob nomatch menucomplete interactivecomments
setopt inc_append_history sharehistory hist_ignore_space hist_save_no_dups hist_ignore_dups hist_find_no_dups
unsetopt beep
stty stop undef 2>/dev/null || true

autoload -Uz compinit
compinit

if command -v fzf >/dev/null 2>&1; then
  bindkey '^R' fzf-history-widget
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi
