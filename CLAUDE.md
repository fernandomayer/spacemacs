# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains a personal Spacemacs configuration. It consists of:

- `spacemacs.el` — the main `.spacemacs` dotfile (installed at `~/.spacemacs`)
- `private/` — custom private layers to be placed at `~/.emacs.d/private/`

To deploy: copy `spacemacs.el` to `~/.spacemacs` and symlink or copy the `private/` subdirectories into `~/.emacs.d/private/`. Then add the layer names to `dotspacemacs-configuration-layers` in `.spacemacs`.

## Private Layers

### `ess`
A fork of the official Spacemacs ESS layer with:
- R indentation style set to `C++` (via `ess-set-style`)
- `ess-enable-smartparens` variable added (disabled by default; enable in `.spacemacs` like `ess-enable-smart-equals`)
- `ess-eval-visibly` set to `t` so sent code appears in the console
- `ess-indent-with-fancy-comments` disabled
- Custom R pipe helpers bound to `M-p` (magrittr `%>%`) and `M-o` (native `|>`)
- `M--` inserts the assignment operator (`<-`)
- `M-k` inserts knitr/Quarto chunk options (`#| `)
- `C-.` sends `dev.off()` to the R process (bound in R buffers, iESS, markdown, polymode, and quarto modes)
- `C-c C-p` runs `ess-eval-paragraph` scoped to R code chunks only (polymode-aware)
- `C-:` prepends a function with its namespace (e.g., `mean` → `stats::mean`)
- Local packages in `private/ess/local/`: `electric-spacing-r`, `essh`
- Also loads `essgd` for in-buffer plot display

### `polymode`
Wires up polymode for mixed-language files:
- `.Rmd` → `poly-markdown+r-mode`
- `.Rnw` → `poly-noweb+r-mode`
- `.qmd` → `poly-quarto-mode`

### `funk`
Personal functions and global keybindings (no packages installed):

| Key | Function |
|-----|----------|
| `C-c i` | `insert-chunk` — insert empty R markdown code chunk |
| `C-c n` | `insert-chunk-name` — insert knitr externalization comment `## ----- ` |
| `C-c r` | `ess-eval-word` — evaluate R object/function at point |
| `C-c d` | `duplicate-line` |
| `M-;` | `comment-line-or-region` |
| `C-M--` | Insert commented rule of dashes to fill column |
| `C-M-=` | Insert commented rule of equals to fill column |
| `C--` | Insert 43-dash commented divider |
| `M-[` / `M-]` | Move line up/down |
| `M-{` / `M-}` | Move region up/down |
| `F5` | `revert-buffer-no-confirm` |
| `C-<insert>` | `quick-copy-line` |
| `s-<delete>` | `quick-cut-line` |
| `C-TAB` | `other-window` |
| `C-+` / `C--` | Increase/decrease font size |

### `elpy`
Third-party layer for Python support via `elpy`. Do **not** enable alongside the built-in `python` layer.

## Key `spacemacs.el` Settings

- **Editing style**: `emacs` (not vim/hybrid)
- **Fill column**: 80, with `auto-fill-mode` enabled globally
- **ESS backend**: `lsp` with `ess-use-flymake` disabled
- **gptel**: configured to use GitHub Copilot backend with `claude-sonnet-4.5` model; auto-scrolls and fills responses
- **Layers active**: `csv`, `helm`, `treemacs`, `auto-completion`, `git`, `markdown`, `org`, `latex`, `rust`, `html`, `yaml`, `bm`, `docker`, `ess`, `funk`, `polymode`, `elpy`, `ipython-notebook`
- **Additional packages**: `gptel`, `gptel-commit`, `poly-R`, `quarto-mode`, `poly-noweb`, `poly-org`, `poly-markdown`, `copilot`

## Layer File Structure

Each layer under `private/` follows Spacemacs conventions:
- `packages.el` — declares `<layer>-packages` list and `<layer>/init-<pkg>` / `<layer>/post-init-<pkg>` functions
- `config.el` — sets layer-scoped variables before packages load
- `funcs.el` — pure function definitions (no `use-package`)
- `keybindings.el` — global key bindings only

When adding a new package to a layer, declare it in `packages.el`'s `<layer>-packages` list and provide an `init-` function. For post-initialization hooks on packages owned by another layer, use `post-init-`.
