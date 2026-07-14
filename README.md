# Salad's Neovim Config

## Architecture

```
~/.config/nvim/
├── init.la                  # entry point -> require("salad")
├── lazy-lock.json           # locked plugin versions
├── after/plugin/colors.lua  # transparent bg override
└── lua/salad/
    ├── init.lua             # mapleader, loads submodules
    ├── settings.lua         # editor options
    ├── remaps.lua           # global keymaps
    ├── lazy_init.lua        # lazy.nvim bootstrap
    └── lazy/                # per-plugin specs
        ├── theme.lua        # catppuccin
        ├── treesitter.lua   # nvim-treesitter
        ├── mason.lua        # mason + lspconfig
        ├── cmp.lua          # nvim-cmp + LuaSnip
        ├── telescope.lua    # telescope.nvim
        ├── conform.lua      # conform.nvim
        ├── fugitive.lua     # vim-fugitive
        ├── undotree.lua     # undotree
        ├── lualine.lua      # lualine.nvim
        └── lazydev.lua      # lazydev.nvim
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
| incsearch | on |
| termguicolors | on |

Transparent background via `after/plugin/colors.lua`.

---

## Global Keymaps

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `<leader>pv` | `:Ex` | Netrw explorer |
| n | `<leader>pf` | Telescope | Find files |
| n | `<leader>pg` | Telescope | Live grep |
| n | `<leader>pb` | Telescope | Buffers |
| n | `<leader>ph` | Telescope | Help tags |
| n | `<C-p>` | Telescope | Git files |

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

`pyright`, `vtsls`, `html`, `cssls`, `tailwindcss`, `gopls`, `rust_analyzer`, `clangd`, `jsonls`

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

## vim-fugitive (Git)

| Key | Action |
|---|---|
| `<leader>gs` | Git status |
| `<leader>gd` | Git diff split |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |

---

## Undotree

| Key | Action |
|---|---|
| `<leader>u` | Toggle undotree |

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
| `<leader>pf` | Telescope | Find files |
| `<leader>pg` | Telescope | Live grep |
| `<leader>pb` | Telescope | Buffers |
| `<leader>ph` | Telescope | Help tags |
| `<leader>ca` | LSP | Code action |
| `<leader>rn` | LSP | Rename |
| `<leader>e` | LSP | Line diagnostics |
| `<leader>gs` | Fugitive | Git status |
| `<leader>gd` | Fugitive | Git diff split |
| `<leader>gc` | Fugitive | Git commit |
| `<leader>gp` | Fugitive | Git push |
| `<leader>u` | Undotree | Toggle undo tree |
