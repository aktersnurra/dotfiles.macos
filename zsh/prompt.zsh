autoload -Uz vcs_info colors
colors

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats ' %F{8}%m%u%c%F{8} %F{9}%b%f'

+vi-git-untracked() {
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == true ]] \
    && git status --porcelain | grep -q '^??'; then
    hook_com[staged]+='!'
  fi
}

prompt-vcs-info() {
  vcs_info
}

set-prompt() {
  local top_left='%(5~|%-1~/…/%3~|%4~)'
  local top_right="$vcs_info_msg_0_ "
  local bottom_left='%B%F{%(?.white.red)}%#%f%b %{${reset_color}%}'
  PROMPT="${top_left}${top_right}"$'\n'"${bottom_left} "
}

precmd_functions+=(prompt-vcs-info set-prompt)
setopt prompt_subst
