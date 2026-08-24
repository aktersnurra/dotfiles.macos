lfcd() {
  local tmp
  local directory
  tmp="$(mktemp)" || return 1
  lf -last-dir-path="$tmp" "$@"
  if [[ -f "$tmp" ]]; then
    directory="$(<"$tmp")"
    rm -f "$tmp"
    [[ -d "$directory" && "$directory" != "$PWD" ]] && cd "$directory"
  fi
}

bindkey -s '^o' 'lfcd\n'
