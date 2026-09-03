bindkey -v
export KEYTIMEOUT=1

if bindkey -lL | command grep -qx 'bindkey -N menuselect'; then
  bindkey -M menuselect '^h' vi-backward-char
  bindkey -M menuselect '^j' vi-down-line-or-history
  bindkey -M menuselect '^k' vi-up-line-or-history
  bindkey -M menuselect '^l' vi-forward-char
fi
bindkey -v '^?' backward-delete-char

zle-keymap-select() {
  case "$KEYMAP" in
    vicmd) print -n '\e[1 q' ;;
    viins|main) print -n '\e[5 q' ;;
  esac
}
zle -N zle-keymap-select

zle-line-init() {
  zle -K viins
  print -n '\e[5 q'
}
zle -N zle-line-init
preexec() { print -n '\e[5 q'; }
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
