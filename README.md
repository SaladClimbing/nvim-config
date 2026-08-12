# Salad's Neovim Config

A batteries-included Neovim configuration built on **lazy.nvim**. Focused on
LSP-driven development, fuzzy finding, and a clean, distraction-free UI — all
with minimal ceremony.

Highlights:

- **blink.cmp** completion (LSP, path, snippets, buffer sources)
- **mini.nvim** suite for editing, git diff gutter, tabline, and colors
- **Mason + lspconfig** LSP servers, auto-installed on first run
- **conform.nvim** format-on-save across languages
- **Telescope** fuzzy finder (files, grep, buffers, git)
- **render-markdown** live Markdown preview
- Seamless **tmux** pane navigation

> Complete keymap reference: [`keybinds.md`](keybinds.md)

---

## Install

### Prerequisites

| Requirement | Notes |
|---|---|
| **macOS** | Nothing — script installs Homebrew if missing |
| **Linux** | `sudo` (for package manager commands) |

One-liner for a fresh Linux or macOS machine (SSH-friendly):

```bash
curl -fsSL https://raw.githubusercontent.com/SaladClimbing/nvim-config/main/install.sh | bash
```

What it does:

- Installs system dependencies: git, node, go, rust, ripgrep, fd, build tools
- Installs the latest Neovim (tarball to `/opt` on Linux, brew on macOS)
- Clones this config to `~/.config/nvim` (backs up an existing one)
- Installs all plugins via lazy.nvim
- Triggers Mason to auto-install LSP servers and formatters on first `nvim`

After the script finishes, reload your shell config to use `nvim` right away:

```bash
source ~/.zshrc   # or ~/.bashrc / ~/.profile
```

### Options

| Flag | Description |
|---|---|
| `-v`, `--verbose` | Show all install output (no progress bar) |
| `--install-font` | Install JetBrainsMono Nerd Font |
| `--help` | Show usage |
| `<repo-url>` | Use a different config repo |

```bash
# Custom config + font
curl -fsSL https://raw.githubusercontent.com/SaladClimbing/nvim-config/main/install.sh | bash -s --install-font git@github.com:user/other-config.git
```

---

## Architecture

```
~/.config/nvim/
├── init.lua                  # entry point -> require("salad")
├── keybinds.md               # full keymap reference
├── lazy-lock.json            # locked plugin versions
├── after/plugin/colors.lua   # transparent bg override
├── install.sh                # one-shot setup script
└── lua/salad/
    ├── init.lua              # mapleader, loads submodules
    ├── settings.lua          # editor options, autocmds, colorscheme
    ├── remaps.lua            # global keymaps
    ├── lazy_init.lua         # lazy.nvim bootstrap
    └── lazy/                 # per-plugin specs
        ├── theme.lua         # catppuccin
        ├── treesitter.lua    # nvim-treesitter (highlight, folding)
        ├── mason.lua         # mason + lspconfig (LSP keymaps here)
        ├── telescope.lua     # telescope.nvim
        ├── blink.lua         # blink.cmp completion
        ├── conform.lua       # conform.nvim (format on save)
        ├── lualine.lua       # lualine.nvim
        ├── lazydev.lua       # lazydev.nvim
        ├── whichkey.lua      # which-key.nvim
        ├── fidget.lua        # fidget.nvim
        ├── neotab.lua        # neotab.nvim
        ├── tpipeline.lua     # vim-tpipeline
        ├── markdown.lua      # render-markdown.nvim
        ├── vim-tmux-navigator.lua  # tmux pane navigation
        └── mini.lua          # mini.nvim modules
```

---

## Leader Key

`<space>`

---

## Settings

| Option | Value |
|---|---|
| colorscheme | catppuccin |
| line numbers | relative (`nu` + `relativenumber`) |
| tab width / shift | 4 |
| expandtab / smartindent | on |
| wrap | off |
| textwidth | 0 |
| incsearch | on |
| termguicolors | on |
| folding | treesitter (`expr`, `foldlevel = 99`) |
| hidden / switchbuf | on / `usetab` |

Set in `lua/salad/settings.lua` and `lua/salad/remaps.lua`.

- Transparent background via `after/plugin/colors.lua`.
- Netrw buffers are hidden from the buffer list and wiped on hide.
- Wrap is disabled both globally and per-filetype.

---

## Hardmode

Arrow keys are disabled in normal and insert mode (`lua/salad/remaps.lua`).
Pressing an arrow key shows `KEY DISABLED` — use `h/j/k/l` instead.

---

## Plugins

### Completion — blink.cmp

Fast, native-feeling autocompletion with sources: `lsp`, `path`, `snippets`,
`buffer`. Ghost text preview, auto-showing documentation, and a configurable
fuzzy matcher.

- **Keymaps**: `<Tab>` select-next, `<S-Tab>` select-prev, `<CR>` accept
  (see [keybinds.md](keybinds.md#completion--blinkcmp))

### Fuzzy Finder — telescope.nvim

Fuzzy searching over files, grep results, buffers, help tags, and git files,
with fzf-native for speed.

- **Keymaps**: `<leader>pf` find files, `<leader>pg` live grep, `<leader>pb` /
  `<leader>bb` list buffers, `<leader>ph` help tags, `<C-p>` git files

### LSP — mason.nvim + nvim-lspconfig

LSP servers are auto-installed via Mason and wired up by lspconfig. Buffer-local
keymaps are applied on `LspAttach`, and inlay hints are enabled where supported.

- **Keymaps**: `gd` definition, `gr` references, `gI` implementation, `gy` type
  definition, `K` hover, `gD` declaration, `<leader>ca` code action,
  `<leader>rn` rename, `<leader>e` / `<leader>d` diagnostics, `[d` / `]d`
  previous/next diagnostic
- **Mason tools**: formatters/linters auto-installed on first run (see below)

### Formatting — conform.nvim

Format on save (500ms timeout, LSP fallback). Per-filetype formatters:

| Filetype | Formatter(s) |
|---|---|
| lua | stylua |
| python | ruff_fix, ruff_format |
| js/ts/jsx/tsx | prettierd |
| html/css/json/md | prettierd |
| go | goimports, gofmt |
| c/cpp | clang-format |
| rust | rustfmt |

### Editing & Workflow — mini.nvim

Five self-contained modules replace the older custom implementations:

- **mini.comment** — `gcc` comment line, `gc{motion}` comment motion, `gc` in visual
- **mini.pairs** — auto-pairing brackets/quotes; `<BS>` deletes an empty pair
- **mini.surround** — `sa` add, `sd` delete, `sf`/`sF` find, `sh` highlight,
  `sr` replace, `sn` update n-lines
- **mini.diff** — git diff gutter in the sign column; `]h`/`[h` navigate hunks,
  `gh` stage, `gH` reset
- **mini.trailspace** — trailing-whitespace highlighting; `:MiniTrailspaceClean`
  removes it

Also provides the buffer **tabline** (mini.tabline, replacing the default tab
line), buffer removal used by the buffer keymaps (mini.bufremove), and inline
**hex-color highlighting** (mini.hipatterns, replacing nvim-colorizer).

### Smart Tab — neotab.nvim

In insert mode, `<Tab>` jumps between paired brackets/quotes
(`() [] {} '' "" \`\` <>`) and across indentation levels; `<S-Tab>` reverses.

### Markdown — render-markdown.nvim

Live in-buffer rendering of Markdown: headings, checkboxes, code blocks,
tables, and images. Renders as you type — no keymaps needed.

### Syntax & Folding — nvim-treesitter

Highlighting and expression folding for all installed parsers; new language
parsers auto-install on first open.

### Statusline — lualine.nvim

Clean statusline with web-dev-icons. The LSP progress spinner from
**fidget.nvim** integrates with it.

### Lua Dev — lazydev.nvim

Better Lua LSP experience in this config's own files; loads luvit types when
`vim.uv` is referenced.

### Tmux — vim-tmux-navigator + vim-tpipeline

Seamless cursor movement between Neovim windows and tmux panes.

- **Keymaps**: `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` move between panes,
  `<C-\>` previous pane
- vim-tpipeline keeps the tmux statusline clean and uncluttered.

### Keymap Cheatsheet — which-key.nvim

Press `<leader>` (or wait) for a popup listing the available keymaps.

- **Keymaps**: `<leader>?` shows buffer-local keymaps only
- Groups: `<leader>p` Telescope, `<leader>b` Buffer

### Theme — catppuccin

Catppuccin colorscheme with a transparent background override.

---

## LSP Servers Installed

`basedpyright`, `vtsls`, `html`, `cssls`, `tailwindcss`, `gopls`,
`rust_analyzer`, `clangd`, `jsonls`

Mason tools auto-installed: `ruff`, `prettierd`, `stylua`, `clang-format`,
`goimports`, `golangci-lint`, `markdownlint`, `jq`, `eslint_d`

---

## Keybinds

See [`keybinds.md`](keybinds.md) for the complete, up-to-date keymap reference,
including plugin default keymaps.
