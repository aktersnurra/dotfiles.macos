# macOS dotfiles

Public zsh and Ghostty configuration for macOS.

## Scope

This repository owns shell preferences and terminal configuration. It does not install packages or manage GitHub CLI credentials.

The MacBook setup installs these dependencies:

- zsh-autosuggestions
- zsh-syntax-highlighting
- fzf
- zoxide
- lf
- Ghostty

Home Manager links the `zsh`, `shell`, and `ghostty` directories from this mutable checkout. The files do not enter the Nix store.

## Shell

`zsh/.zshrc` loads portable and Darwin shell settings. It also loads aliases, functions, prompt settings, and vi mode.

The shell loads plugins only when Nix provides their configured paths. It does not clone plugins during startup.

## Exclusions

This repository excludes Linux-specific X11, CUDA, OPAM, model storage, fixed paths, global language-manager startup, and credential integration.

macbook-setup owns GitHub CLI and 1Password integration.

## Verification

```sh
bash tests/shell-test.sh
bash tests/content-test.sh
bash tests/adoption-test.sh
```
