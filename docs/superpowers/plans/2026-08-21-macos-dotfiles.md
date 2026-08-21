# macOS Dotfiles Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create public, portable macOS dotfiles with zsh and Ghostty configuration.

**Architecture:** This repository owns mutable shell and Ghostty files. Nix installs required commands and plugins. macbook-setup owns all GitHub CLI and 1Password integration.

**Tech Stack:** zsh, Bash tests, Ghostty configuration.

---

## File Structure

- Create `.gitignore`: Exclude local temporary data.
- Create `zsh/.zshrc`: Source portable and Darwin shell behavior.
- Create `zsh/aliases.zsh`: Portable aliases only.
- Create `zsh/functions.zsh`: `lfcd` and other portable functions.
- Create `zsh/prompt.zsh`: Prompt configuration.
- Create `zsh/vi-mode.zsh`: Vi-mode configuration.
- Create `shell/portable.zsh`: XDG, history, completion, fzf, zoxide, lf, and GPG settings.
- Create `shell/darwin.zsh`: macOS-only shell behavior.
- Create `ghostty/config`: Ghostty terminal configuration.
- Create `tests/shell-test.sh`: Test shell loading.
- Create `tests/content-test.sh`: Reject credential integration and Linux-only settings.
- Create `tests/adoption-test.sh`: Reject runtime plugin cloning, hard-coded paths, and unguarded optional commands.
- Create `README.md`: Document Nix dependencies and links.

### Task 1: Add Failing Shell Tests

**Files:**

- Create: `tests/test-helper.sh`
- Create: `tests/shell-test.sh`

- [ ] **Step 1: Create assertion helpers**

Create `tests/test-helper.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }
```

- [ ] **Step 2: Create the shell behavior test**

Create `tests/shell-test.sh`. Make a temporary home directory. Source `zsh/.zshrc` with zsh. Assert the command succeeds without credential files or environment values.

- [ ] **Step 3: Run the test to verify it fails**

Run: `bash tests/shell-test.sh`

Expected: FAIL because `zsh/.zshrc` does not exist.

- [ ] **Step 4: Describe the test change**

```sh
jj describe -m "test: define macos shell behavior"
jj new
```

### Task 2: Add Portable And Darwin Shell Files

**Files:**

- Create: `shell/portable.zsh`
- Create: `shell/darwin.zsh`
- Create: `zsh/.zshrc`
- Create: `zsh/functions.zsh`
- Create: `zsh/aliases.zsh`
- Create: `zsh/prompt.zsh`
- Create: `zsh/vi-mode.zsh`

- [ ] **Step 1: Add portable behavior**

Create `shell/portable.zsh` with XDG directories, zsh history, `GPG_TTY`, completion, fzf, zoxide, and lf support. Do not add X11, CUDA, OPAM, fixed paths, model storage, token exports, 1Password, or GitHub CLI settings.

- [ ] **Step 2: Add Darwin behavior**

Create `shell/darwin.zsh` with only macOS shell settings:

```zsh
export HOMEBREW_NO_ANALYTICS=1
```

- [ ] **Step 3: Add zsh entry point**

Create `zsh/.zshrc` that sources portable and Darwin shell files, aliases, functions, prompt, vi mode, and Nix plugin paths only when they exist.

- [ ] **Step 4: Add selected functions and aliases**

Implement `lfcd` in `functions.zsh`, portable aliases in `aliases.zsh`, a minimal prompt in `prompt.zsh`, and `bindkey -v` in `vi-mode.zsh`.

- [ ] **Step 5: Run shell test to verify it passes**

Run: `bash tests/shell-test.sh`

Expected: PASS.

- [ ] **Step 6: Describe the change**

```sh
jj describe -m "feat: add portable macos shell"
jj new
```

### Task 3: Add Ghostty And Content Safety Tests

**Files:**

- Create: `ghostty/config`
- Create: `tests/content-test.sh`
- Create: `.gitignore`

- [ ] **Step 1: Create content safety test**

Create `tests/content-test.sh` that rejects these strings in tracked configuration:

```text
BEGIN .*PRIVATE KEY
GH_TOKEN_OP_REF
1password
op run
/opt/cuda
LD_LIBRARY_PATH
startx
XAUTHORITY
OPAMROOT
/storage
```

The test must also require `ghostty/config` with `command = /bin/zsh`.

- [ ] **Step 2: Run content test to verify it fails**

Run: `bash tests/content-test.sh`

Expected: FAIL because `ghostty/config` does not exist.

- [ ] **Step 3: Add Ghostty config and ignore rules**

Create `ghostty/config`:

```text
command = /bin/zsh
shell-integration = zsh
font-family = Menlo
font-size = 13
```

Create `.gitignore`:

```gitignore
*.key
*.pem
*.asc
.env
```

- [ ] **Step 4: Run content test to verify it passes**

Run: `bash tests/content-test.sh`

Expected: PASS.

- [ ] **Step 5: Describe the change**

```sh
jj describe -m "feat: add ghostty configuration"
jj new
```

### Task 4: Add Installation Documentation

**Files:**

- Create: `README.md`

- [ ] **Step 1: Document dependencies and links**

State that macbook-setup supplies `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`, `zoxide`, `lf`, and Ghostty. Document Home Manager out-of-store links for `zsh`, `shell`, and `ghostty`.

- [ ] **Step 2: Document exclusions**

List excluded Linux-only settings. State that macbook-setup owns GitHub CLI credential integration. Do not add a migration table.

- [ ] **Step 3: Run all tests and lint**

Run:

```sh
bash tests/shell-test.sh
bash tests/content-test.sh
bash tests/adoption-test.sh
nix shell nixpkgs#shellcheck --command shellcheck tests/*.sh
```

Expected: PASS with no diagnostics.

- [ ] **Step 4: Review before publication**

Run:

```sh
jj status
jj diff --git
rg -n '(BEGIN .*PRIVATE KEY|GH_TOKEN_OP_REF|1password|op run|/opt/cuda|startx|XAUTHORITY|OPAMROOT|/storage)' .
```

Expected: no prohibited configuration appears.

- [ ] **Step 5: Describe the change**

```sh
jj describe -m "docs: add macos dotfiles usage"
```

### Task 5: Enforce Adoption Cleanup

**Files:**

- Create: `tests/adoption-test.sh`

- [ ] **Step 1: Add the adoption boundary test**

Create `tests/adoption-test.sh`. It must fail if shell files contain these patterns:

```text
git clone
/home/
PATH="/opt/
startx
XAUTHORITY
OPAMROOT
CUDA
LD_LIBRARY_PATH
OLLAMA_MODELS
HF_HOME
```

It must also fail when `zsh/.zshrc` sources a plugin path without first testing that the path is readable.

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/adoption-test.sh`

Expected: FAIL because shell files do not exist.

- [ ] **Step 3: Implement the smallest compatible port**

Carry over only portable shell behavior: vi mode, history, zsh options, fzf history binding, `lfcd`, completion, prompt, and aliases with macOS dependencies. Use quoted paths and `command -v` guards. Use `eval` only for `zoxide init`.

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/adoption-test.sh`

Expected: PASS.

- [ ] **Step 5: Run the complete shell suite**

Run:

```sh
bash tests/shell-test.sh
bash tests/content-test.sh
bash tests/adoption-test.sh
```

Expected: PASS.

- [ ] **Step 6: Describe the change**

```sh
jj describe -m "refactor: clean macos shell adoption"
```
