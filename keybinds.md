# Keybinds

Complete reference for every keymap in this configuration.

- `<leader>` = `<space>` (set in `lua/salad/init.lua`)
- **Mode**: `n` normal, `i` insert, `v` visual, `o` operator-pending, `x` visual+select
- Custom maps live in `lua/salad/remaps.lua` and per-plugin specs in `lua/salad/lazy/`
- Plugin default keymaps are marked with a "default" note

---

## Global & Buffer (`lua/salad/remaps.lua`)

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `<leader>bn` | `:enew` | Open a new empty buffer |
| n | `<leader>bd` | `mini.bufremove.delete()` | Close buffer |
| n | `<leader>bD` | `mini.bufremove.delete(nil, true)` | Force-close buffer (discards changes) |
| n | `<S-h>` | `:bprev` | Go to previous buffer |
| n | `<S-l>` | `:bnext` | Go to next buffer |
| n | `<leader>bb` | `Telescope buffers` | List open buffers |
| n | `<leader>pv` | `:Ex` | Open file explorer (netrw) |

> Tab / S-Tab buffer switching is disabled: `<Tab>`/`<S-Tab>` are used by
> blink.cmp and neotab for completion and smart indentation.

---

## Telescope — fuzzy finder (`lua/salad/lazy/telescope.lua`)

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `<leader>pf` | `find_files` | Find files |
| n | `<leader>pg` | `live_grep` | Live grep (content search) |
| n | `<leader>pb` | `buffers` | List open buffers |
| n | `<leader>ph` | `help_tags` | Search help tags |
| n | `<C-p>` | `git_files` | Search git-tracked files |

---

## Diagnostics

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `<leader>d` | `vim.diagnostic.open_float` | Show line diagnostics (global) |
| n | `<leader>e` | `vim.diagnostic.open_float` | Show line diagnostics (per-buffer, LSP) |
| n | `[d` | `vim.diagnostic.goto_prev` | Go to previous diagnostic |
| n | `]d` | `vim.diagnostic.goto_next` | Go to next diagnostic |

---

## LSP (`lua/salad/lazy/mason.lua`)

Buffer-local keymaps, set automatically when an LSP server attaches.

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `gd` | `telescope lsp_definitions` | Goto definition |
| n | `gr` | `telescope lsp_references` | Find references |
| n | `gI` | `telescope lsp_implementations` | Goto implementation |
| n | `gy` | `telescope lsp_type_definitions` | Goto type definition |
| n | `gD` | `vim.lsp.buf.declaration` | Goto declaration |
| n | `K` | `vim.lsp.buf.hover` | Hover documentation |
| n | `<leader>ca` | `vim.lsp.buf.code_action` | Code action |
| n | `<leader>rn` | `vim.lsp.buf.rename` | Rename symbol |

Inlay hints are enabled automatically when the attached server supports them.

---

## Completion — blink.cmp (`lua/salad/lazy/blink.lua`)

Insert-mode keymaps (super-tab preset, with overrides). `fallback` means the key
performs its normal (non-completion) action when the menu is closed.

| Mode | Key | Action | Description |
|---|---|---|---|
| i | `<Tab>` | `select_next`, `fallback` | Select next item / tab |
| i | `<S-Tab>` | `select_prev`, `fallback` | Select previous item / shift-tab |
| i | `<CR>` | `accept`, `fallback` | Accept selected item / newline |
| i | `<C-space>` | `show`, docs, hide docs | Trigger completion + docs (default) |
| i | `<C-e>` | `cancel`, `fallback` | Cancel completion (default) |
| i | `<Up>` / `<Down>` | `select_prev` / `select_next` | Move through items (default) |
| i | `<C-p>` / `<C-n>` | `select_prev` / `select_next` | Move through items (default) |
| i | `<C-b>` / `<C-f>` | scroll docs up / down | Scroll documentation (default) |
| i | `<C-k>` | `show_signature`, `hide_signature` | Toggle signature help (default) |

---

## Smart Tab — neotab (`lua/salad/lazy/neotab.lua`)

Insert-mode smart tab inside paired brackets/quotes (`() [] {} '' "" \`\` <>`)
and across indentation levels.

| Mode | Key | Action | Description |
|---|---|---|---|
| i | `<Tab>` | — | Jump to next pair / indent level |
| i | `<S-Tab>` | — | Jump to previous pair / outdent |

---

## mini.nvim modules (`lua/salad/lazy/mini.lua`)

### mini.comment (default)

| Mode | Key | Action |
|---|---|---|
| n | `gcc` | Toggle comment on current line |
| n | `gc{motion}` | Toggle comment on motion region |
| n | `gcgc` | Uncomment current line |
| v | `gc` | Toggle comment on selection |

### mini.pairs (default)

| Mode | Key | Action |
|---|---|---|
| i | `( [ { ' " \`` | Auto-insert closing pair |
| i | `<BS>` | Delete pair when backspacing inside an empty pair |

### mini.surround (default)

| Mode | Key | Action |
|---|---|---|
| n | `sa` | Add surround (`sa"` then motion) |
| n | `sd` | Delete surround |
| n | `sf` | Find surrounding pair to the right |
| n | `sF` | Find surrounding pair to the left |
| n | `sh` | Highlight surrounding pair |
| n | `sr` | Replace surround |
| n | `sn` | Update n-lines for surround |

### mini.diff — git diff gutter (default)

| Mode | Key | Action |
|---|---|---|
| n | `]h` | Go to next hunk |
| n | `[h` | Go to previous hunk |
| n | `]H` | Go to last hunk |
| n | `[H` | Go to first hunk |
| n/x | `gh` | Apply (stage) hunk in region |
| n/x | `gH` | Reset hunk in region |
| o | `gh` | "Hunk range" textobject |

### mini.trailspace (default)

No keymaps. Commands:

| Command | Action |
|---|---|
| `:MiniTrailspaceClean` | Remove trailing whitespace |
| `:MiniTrailspaceTrimLastLines` | Trim trailing empty lines |

---

## Tmux navigation (`lua/salad/lazy/vim-tmux-navigator.lua`)

Seamless movement between Neovim windows and tmux panes.

| Mode | Key | Action |
|---|---|---|
| n | `<C-h>` | Move to pane left |
| n | `<C-j>` | Move to pane down |
| n | `<C-k>` | Move to pane up |
| n | `<C-l>` | Move to pane right |
| n | `<C-\>` | Go to previous pane |

---

## which-key (`lua/salad/lazy/whichkey.lua`)

| Mode | Key | Action | Description |
|---|---|---|---|
| n | `<leader>?` | `which-key.show({global=false})` | Show buffer-local keymaps |

Press `<leader>` and wait to see the popup cheatsheet. Registered groups:

| Prefix | Group |
|---|---|
| `<leader>p` | Telescope |
| `<leader>b` | Buffer |

---

## Hardmode (disabled keys)

Arrow keys are disabled in normal and insert mode. Pressing one shows
`KEY DISABLED`. Use `h/j/k/l` and insert-mode alternatives instead.

| Mode | Disabled keys |
|---|---|
| n | `<Up>` `<Down>` `<Left>` `<Right>` |
| i | `<Up>` `<Down>` `<Left>` `<Right>` |
