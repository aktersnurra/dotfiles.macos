# macOS Dotfiles Design

## Goal

Create a public macOS dotfiles repository. It provides portable zsh preferences and Ghostty configuration.

## Repository contents

```text
zsh/.zshrc
zsh/aliases.zsh
zsh/functions.zsh
zsh/prompt.zsh
zsh/vi-mode.zsh
shell/portable.zsh
shell/darwin.zsh
ghostty/config
README.md
```

The repository contains no private keys, tokens, 1Password integration, GPG key IDs, usernames, email addresses, fixed home paths, or repository URLs.

## Shell files

`portable.zsh` contains XDG settings, history, `GPG_TTY`, completion, fzf, zoxide, and lf support.

`darwin.zsh` contains macOS-only shell settings. It does not contain Linux, X11, CUDA, OPAM, model-storage, workstation, 1Password, or GitHub token settings.

`.zshrc` loads both shell files plus aliases, functions, prompt, and vi-mode. It sources Nix-provided plugins only when their paths exist.

## Dependencies

The MacBook setup installs these dependencies:

- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `fzf`
- `zoxide`
- `lf`
- Ghostty

The dotfiles repository does not clone plugins or install packages during shell startup.

## Exclusions

Do not copy these old configuration classes:

- X11 startup and display variables
- CUDA paths and library paths
- OPAM startup
- fixed home paths
- model storage paths
- local browser and terminal defaults
- automatic plugin cloning
- credential integration

## Adoption cleanup

The implementation reviews the public Linux dotfiles before it adds each macOS shell behavior. It retains only portable behavior that has a macOS dependency.

The new files use quoted paths, `command -v` checks for optional tools, and one source file for each concern. They do not clone plugins at shell startup. They do not set global language-manager state.

The repository does not include a migration table. Tests enforce the intended code boundaries.

## MacBook integration

The MacBook setup treats this repository as an optional external repository. Home Manager creates approved out-of-store links after the repository checkout exists.

The MacBook setup installs dependencies. This repository owns only shell and terminal files. The MacBook setup owns GitHub CLI credential integration.

## Verification

Tests run shell files in a temporary home directory. They verify shell loading and reject prohibited platform-specific settings and credential integration.
