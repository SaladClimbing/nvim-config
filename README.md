# Salad's Neovim Config

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
- Installs system dependencies: git, node, go, rust, ripgrep, fd-find, build tools
- Installs latest Neovim (AppImage on Linux, brew on macOS)
- Clones this config to `~/.config/nvim` (backsup existing)
- Installs all plugins via lazy.nvim
- Triggers Mason to auto-install LSP servers and formatters

After the script finishes, reload your shell config to use `nvim` right away:

```bash
source ~/.bashrc
```

(Replace `~/.bashrc` with `~/.zshrc` or `~/.profile` depending on your shell.)

Options:
| Flag | Description |
|---|---|
| `--install-font` | Install JetBrainsMono Nerd Font |
| `--help` | Show usage |
| `<repo-url>` | Use a different config repo |

```bash
# Custom config + font
curl -fsSL https://raw.githubusercontent.com/SaladClimbing/nvim-config/main/install.sh | bash -s --install-font git@github.com:user/other-config.git
```

## Architecture

```
~/.config/nvim/
├── init.lua                  # entry point -> require("salad")
├── lazy-lock.json            # locked plugin versions
├── after/plugin/colors.lua   # transparent bg override
├── install.sh                # one-shot setup script
└── lua/salad/
    ├── init.lua              # mapleader, loads submodules
    ├── settings.lua          # editor options, autocmds, buffer tabline
    ├── remaps.lua            # global keymaps
    ├── lazy_init.lua         # lazy.nvim bootstrap
    └── lazy/                 # per-plugin specs
        ├── theme.lua         # catppuccin
        ├── treesitter.lua    # nvim-treesitter
        ├── mason.lua         # mason + lspconfig
        ├── cmp.lua           # nvim-cmp + LuaSnip
        ├── telescope.lua     # telescope.nvim
        ├── conform.lua       # conform.nvim
        ├── undotree.lua      # undotree
        ├── lualine.lua       # lualine.nvim
        ├── lazydev.lua       # lazydev.nvim
        ├── whichkey.lua      # which-key.nvim
        ├── fidget.lua        # fidget.nvim
        ├── neotab.lua        # neotab.nvim
        ├── tpipeline.lua     # vim-tpipeline
        └── vim-tmux-navigator.lua  # tmux pane navigation
```

## Leader Key

`<space>`

---

## Settings

| Option | Value |
|---|---|
| colorscheme | catppuccin |
| nu / relativenumber | on |
| tabstop / shiftwidth | 4 |
| expandtab / smartindent | on |
| wrap | off |
| textwidth | 0 |
| incsearch | on |
| termguicolors | on |
| hidden | on |
| switchbuf | usetab |
| showtabline | 2 |

Transparent background via `after/plugin/colors.lua`.

### Buffer Tabline

A custom VS Code-style tabline replaces the default tab line. Shows all listed buffers with modified indicators. Filetypes like `netrw`, `qf`, `help`, `TelescopePrompt`, `undotree`, `lspinfo`, and `mason` are hidden from the tabline. Refreshes on `BufEnter`, `BufAdd`, `BufDelete`, and `BufWritePost`.

---

## Global Keymaps

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `<leader>pv` | `:Ex` | File explorer |
| n | `<Tab>` | `:bnext` | Next buffer |
| n | `<S-Tab>` | `:bprev` | Previous buffer |
| n | `<leader>bn` | `:enew` | New buffer |
| n | `<leader>bd` | `:bd` | Close buffer |
| n | `<leader>bD` | `:bd!` | Force close buffer |
| n | `<S-h>` | `:bprev` | Previous buffer |
| n | `<S-l>` | `:bnext` | Next buffer |
| n | `<leader>bb` | Telescope | List buffers |
| n | `<leader>pf` | Telescope | Find files |
| n | `<leader>pg` | Telescope | Live grep |
| n | `<leader>pb` | Telescope | Buffers |
| n | `<leader>ph` | Telescope | Help tags |
| n | `<C-p>` | Telescope | Git files |
| n | `<c-h>` | tmux-navigator | Tmux pane left |
| n | `<c-j>` | tmux-navigator | Tmux pane down |
| n | `<c-k>` | tmux-navigator | Tmux pane up |
| n | `<c-l>` | tmux-navigator | Tmux pane right |
| n | `<c-\>` | tmux-navigator | Tmux previous pane |

---

## LSP Keymaps (set per-buffer on LspAttach)

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `gd` | Telescope | Goto Definition |
| n | `gr` | Telescope | References |
| n | `gI` | Telescope | Goto Implementation |
| n | `gy` | Telescope | Goto Type Definition |
| n | `K` | `vim.lsp.buf.hover` | Hover docs |
| n | `gD` | `vim.lsp.buf.declaration` | Goto Declaration |
| n | `<leader>ca` | `vim.lsp.buf.code_action` | Code action |
| n | `<leader>rn` | `vim.lsp.buf.rename` | Rename |
| n | `<leader>e` | `vim.diagnostic.open_float` | Line diagnostics |
| n | `[d` | `vim.diagnostic.goto_prev` | Prev diagnostic |
| n | `]d` | `vim.diagnostic.goto_next` | Next diagnostic |

Inlay hints enabled on LspAttach when server supports it.

---

## LSP Servers Installed

`basedpyright`, `vtsls`, `html`, `cssls`, `tailwindcss`, `gopls`, `rust_analyzer`, `clangd`, `jsonls`

Mason tools auto-installed: `ruff`, `prettierd`, `stylua`, `clang-format`, `goimports`, `golangci-lint`, `markdownlint`, `jq`, `eslint_d`

---

## nvim-cmp (Autocompletion)

Sources: `nvim_lsp`, `luasnip`, `buffer`, `path`

| Mode | Key | Action |
|---|---|---|
| i | `<C-d>` | Scroll docs down |
| i | `<C-f>` | Scroll docs up |
| i | `<C-Space>` | Force complete |
| i | `<C-e>` | Abort popup |
| i | `<CR>` | Confirm (select first) |
| i,s | `<Tab>` | Next item / expand snippet |
| i,s | `<S-Tab>` | Prev item / jump back |

---

## nvim-treesitter

Parsers: `lua`, `vim`, `vimdoc`, `query`, `markdown`, `python`, `javascript`, `typescript`, `c`, `cpp`, `rust`, `go`

Auto-install: on | Highlight: on

---

## Conform (Format on Save)

500ms timeout, LSP fallback enabled.

| Filetype | Formatter(s) |
|---|---|
| lua | stylua |
| python | ruff_fix, ruff_format |
| js/ts/jsx/tsx | prettierd |
| html/css/json/md | prettierd |
| go | goimports, gofmt |
| c/cpp | clang-format |
| rust | rustfmt |

---

## Undotree

| Key | Action |
|---|---|
| `<leader>u` | Toggle undotree |

---

## which-key.nvim

Keymap popup cheatsheet. Shows available keymaps when `<leader>` is pressed. Groups configured:

| Prefix | Group |
|---|---|
| `<leader>p` | Telescope |
| `<leader>b` | Buffer |
| `<leader>u` | Undotree |

Press `<leader>?` to show available buffer-local keymaps.

---

## vim-tmux-navigator

Seamless pane navigation between Neovim windows and tmux panes using Ctrl+h/j/k/l. Requires `vim-tpipeline` for clean tmux statusline integration.

---

## neotab.nvim

Smart Tab behavior in insert mode. Tab navigates between paired brackets/quotes (`()`, `[]`, `{}`, `''`, `""`, ` `` `, `<>`) and indentation levels.

---

## fidget.nvim

LSP progress spinner displayed in the statusline while LSP servers are loading or processing.

---

## vim-tpipeline

Integrates Neovim's tabline and statusline with tmux, preventing duplicate status bars when using `vim-tmux-navigator`.

---

## Other Plugins

- **lualine.nvim** - statusline (defaults, with web-devicons)
- **lazydev.nvim** - Lua LSP enhancements (loads luvit types on `vim.uv`)
- **catppuccin/nvim** - colorscheme (priority 1000)

---

## All `<leader>` Keybinds Summary

| Key | Plugin | Action |
|---|---|---|
| `<leader>pv` | Netrw | File explorer |
| `<leader>bn` | Buffer | New buffer |
| `<leader>bd` | Buffer | Close buffer |
| `<leader>bD` | Buffer | Force close buffer |

| `<leader>bb` | Telescope | List buffers |
| `<leader>pf` | Telescope | Find files |
| `<leader>pg` | Telescope | Live grep |
| `<leader>pb` | Telescope | Buffers |
| `<leader>ph` | Telescope | Help tags |
| `<leader>ca` | LSP | Code action |
| `<leader>rn` | LSP | Rename |
| `<leader>e` | LSP | Line diagnostics |
| `<leader>u` | Undotree | Toggle undo tree |
| `<leader>?` | which-key | Buffer-local keymaps |
| `<C-p>` | Telescope | Git files |
