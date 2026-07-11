# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

This is a personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — a single-file Neovim configuration (`init.lua`) meant to be read top-to-bottom, not a distribution. Almost all configuration lives in one ~1000-line `init.lua`; small per-plugin overrides live under `lua/kickstart/plugins/*.lua` (stock, opt-in examples) and `lua/custom/plugins/*.lua` (this fork's own additions).

## Commands

- Format Lua: `stylua .` (config in `.stylua.toml`: 160 col width, 2-space indent, single quotes preferred, no parens on single-arg calls). CI (`.github/workflows/stylua.yml`) runs `stylua --check .` on PRs to the upstream repo — always run `stylua .` before committing Lua changes.
- Health check: open Neovim and run `:checkhealth kickstart` (implemented in `lua/kickstart/health.lua`) — verifies Neovim version (>= 0.12) and required external tools.
- There is no test suite or build step; validation is done by launching Neovim and exercising the change (see Verifying changes below).

## Plugin management: `vim.pack`

Plugins are managed with Neovim's built-in `vim.pack` (not lazy.nvim/packer). Key points for editing `init.lua`:

- Install a plugin: `vim.pack.add { gh 'owner/repo' }`, where `gh()` (defined near the top of `init.lua`) expands `owner/repo` to a full GitHub URL. Advanced specs use `{ src = gh 'owner/repo', name = '...', version = vim.version.range '1.*' }`.
- After `vim.pack.add`, most plugins also need `require('plugin').setup { ... }` to actually activate.
- Post-install/update build steps (e.g. `make` for `telescope-fzf-native.nvim`, `TSUpdate` for treesitter) are wired through a single `PackChanged` autocommand — add new build steps there, not as separate autocommands.
- Plugin state is inspected/updated interactively: `:lua vim.pack.update(nil, { offline = true })` to inspect, `:lua vim.pack.update()` to fetch updates (`:write` applies, `:quit` cancels).
- `nvim-pack-lock.json` **is** tracked in this fork (unlike upstream kickstart, which gitignores it — see the comment in `.gitignore`). Commit lockfile changes when plugin versions change.

## `init.lua` structure

The file is organized into numbered `-- SECTION N: ...` blocks, each wrapped in its own `do ... end` scope to keep locals from leaking across sections:

1. **OPTIONS** — `vim.o`/`vim.opt` settings
2. **KEYMAPS** — global keymaps + basic autocommands
3. **PLUGIN MANAGER INTRO** — `vim.pack` explainer, the `gh()` helper, and the `PackChanged` build-hook autocommand
4. **UI / CORE UX PLUGINS** — guess-indent, gitsigns, which-key, colorscheme (catppuccin/mocha), todo-comments, `mini.nvim` modules
5. **SEARCH & NAVIGATION** — telescope + extensions
6. **LSP** — `LspAttach` autocommand (keymaps like `grn`, `gra`, `grD`, inlay-hint toggle), the `servers` table (add/remove language servers here), mason / mason-lspconfig / mason-tool-installer wiring
7. **FORMATTING** — conform.nvim
8. **AUTOCOMPLETE & SNIPPETS** — LuaSnip + blink.cmp
9. **TREESITTER**
10. **OPTIONAL EXAMPLES / NEXT STEPS** — commented-out `require 'kickstart.plugins.*'` lines and the `require 'custom.plugins'` opt-in line

When adding an LSP server, add an entry to the `servers` table in SECTION 6 — `mason-tool-installer` picks up `vim.tbl_keys(servers)` automatically, no separate install-list to maintain.

## Extension points

- `lua/kickstart/plugins/*.lua`: optional, stock example modules (debug, indent_line, lint, autopairs, neo-tree, gitsigns-extra-keymaps). Disabled by default — enabled by uncommenting the matching `require 'kickstart.plugins.X'` line in SECTION 10.
- `lua/custom/plugins/`: this fork's own plugins/overrides. `lua/custom/plugins/init.lua` auto-`require`s every `*.lua` file in that directory (except itself) via `vim.fs.dir` with `follow = true` (symlinks included) — just drop a new file in, no manual wiring needed. Loaded only when SECTION 10's `require 'custom.plugins'` line is uncommented.
- `lua/kickstart/health.lua`: back the `:checkhealth kickstart` command; extend it if adding new external-tool dependencies.

## Editing conventions

- Keep the single-file, heavily-commented style for `init.lua` — this repo is meant to be read as documentation, so prefer keeping related config + explanatory comments together over extracting modules, unless the user asks for a restructure.
- Match `.stylua.toml` formatting (run `stylua .`, don't hand-format Lua) rather than relying on manual spacing.
