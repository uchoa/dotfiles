# Neovim Configuration Architecture & Specification

Modern, modular, and dependency-light Neovim configuration built for **Neovim
0.12+**. This configuration completely replaces external plugin managers (such
as `lazy.nvim`) with Neovim's first-class native package management API
(`vim.pack`), enforces strict one-file-per-plugin isolation, decouples editor
core defaults from third-party extensions, and provides full resilience against
runtime ordering hazards.

---

## 1. Architectural Principles

1. **Native Package Management (`vim.pack`)**:
   - Uses `vim.pack.add()`, `vim.pack.update()`, and `vim.pack.del()` backed by
     Neovim's native lockfile (`pack-lock.json`).
   - Plugin repositories are stored in standard runtime data paths
     (`~/.local/share/nvim/site/pack/`), keeping the dotfiles repository free of
     cloned vendor repositories or git submodules.
   - Declarative `build` steps (e.g. `cd app && bun install`, release binary
     downloads) are automated natively via the `PackChanged` autocommand.
2. **Implicit Lazy Loading**:
   - Plugins declare trigger conditions (`event`, `ft`, `cmd`, `keys`).
   - The custom mini-loader registers unconditioned plugins immediately on
     startup and binds conditioned plugins to single-shot autocommands or
     command stubs that invoke `vim.cmd.packadd()` and execute configuration
     callbacks on-demand.
3. **Decoupled Core (`lua/core/`)**:
   - Global editor options, basic keymaps, and native autocommands execute with
     zero external dependencies.
   - If plugins fail or Neovim is launched with `--noplugin`, the editor
     operates cleanly with predictable vanilla defaults.
4. **Buffer & Filetype Hygiene (`ftplugin/`)**:
   - Filetype-specific options (`textwidth`, `formatoptions`) and buffer-local
     hooks live in native `ftplugin/<filetype>.lua` files, eliminating global
     `FileType` autocommands inside plugin configuration files.
5. **Strict 1-File-Per-Plugin Hierarchy**:
   - Every single plugin is isolated in its own file under `lua/plugins/**`.
   - Plugin-specific keymaps and `which-key` group registrations are colocated
     inside the respective plugin's file, guarded by safe `pcall` checks so
     plugins function seamlessly even if `which-key` is absent.
6. **Native LSP Server Definitions (`lsp/<server>.lua`)**:
   - Completely drops `nvim-lspconfig`.
   - Leverages Neovim 0.12's native server autoloading mechanism where
     `vim.lsp.enable()` automatically discovers and merges `lsp/<server>.lua`
     definitions from `'runtimepath'`.

---

## 2. Directory Tree Layout

```text
~/.config/nvim/
├── init.lua                           # Sets leader, loads 'core', initializes 'pack' loader
├── README.md                          # Architectural specification and reference documentation
│
├── ftplugin/                          # Native Neovim buffer & filetype hooks
│   ├── markdown.lua                   # textwidth=80, TableTidy hook, local markdown bindings
│   ├── go.lua                         # textwidth=80, formatoptions:append("cqro")
│   └── rust.lua                       # textwidth=80, formatoptions:append("cqro")
│
├── lua/
│   ├── core/                          # Pure vanilla Neovim (0 external plugins)
│   │   ├── init.lua                   # Orchestrates core modules
│   │   ├── options.lua                # Clean editor preferences (manual fold fallback)
│   │   ├── keymaps.lua                # Vanilla window/buffer navigation & global maps
│   │   ├── autocmds.lua               # Native autocmds (e.g. TextYankPost highlight)
│   │   └── statusline.lua             # Native Lua statusline (0 plugins, event-synced)
│   │
│   ├── pack/                          # Native vim.pack manager & loader
│   │   └── init.lua                   # • Recursively scans lua/plugins/**
│   │                                  # • Feeds specs to vim.pack.add()
│   │                                  # • Handles build hooks via PackChanged
│   │                                  # • Resolves implicit lazy triggers (event/ft/cmd/keys)
│   │
│   ├── plugins/                       # Strictly ONE file per plugin
│   │   ├── ui/
│   │   │   ├── colorscheme.lua        # no-clown-fiesta + SnacksIndent highlight rules
│   │   │   └── which-key.lua          # Base presets & safe pcall resilience wrapper
│   │   │
│   │   ├── tools/
│   │   │   ├── snacks.lua             # Picker, explorer, indent scope, bufdelete
│   │   │   │                          # (Owns repo-level Git pickers: log, status, branches)
│   │   │   └── gitsigns.lua           # Gutter signs, inline hunk actions & blame line
│   │   │                              # (Owns buffer-level Git mechanics: stage, diff, blame)
│   │   │
│   │   ├── coding/
│   │   │   ├── syntax/                # In-buffer editing syntax & mechanics
│   │   │   │   ├── treesitter.lua     # Parser management + buffer-local fold attachment
│   │   │   │   ├── textobjects.lua    # AST semantic motions (vaf, daa, ]m)
│   │   │   │   ├── autotag.lua        # HTML/JSX tag auto-close/rename
│   │   │   │   ├── completion.lua     # blink.cmp (with prebuilt binary download hook)
│   │   │   │   ├── autopairs.lua      # mini.pairs (zero-overhead auto-pairing)
│   │   │   │   ├── surround.lua       # nvim-surround (preserves instant 's' motion)
│   │   │   │   └── formatting.lua     # conform.nvim (asynchronous formatter)
│   │   │   │
│   │   │   ├── lsp/                   # LSP client ecosystem & diagnostics
│   │   │   │   ├── lsp.lua            # Global vim.lsp capabilities, on_attach & enable
│   │   │   │   ├── lazydev.lua        # LuaLS runtime & plugin typing
│   │   │   │   ├── fidget.lua         # Subtle corner LSP progress notifications
│   │   │   │   └── trouble.lua        # Diagnostics panel + dual section backlink views
│   │   │   │
│   │   │   └── debug/                 # Debugging, testing, and REST
│   │   │       ├── kulala.lua         # HTTP REST client
│   │   │       ├── neotest.lua        # Test framework runner
│   │   │       ├── dap.lua            # nvim-dap core + LLDB (Rust/Zig)
│   │   │       ├── dap-ui.lua         # Debugger UI splits & floating frames
│   │   │       └── dap-go.lua         # Go delve adapter & config
│   │   │
│   │   └── notes/                     # Markdown & documentation tools
│   │       ├── bullets.lua            # bullets-vim/bullets.nvim (Lua list automation)
│   │       ├── render-markdown.lua    # In-buffer markdown styling & icon glyphs
│   │       ├── yamlmatter.lua         # Frontmatter icon rendering
│   │       ├── table-tidy.lua         # Markdown table formatting
│   │       └── preview.lua            # markdown-preview.nvim + terminal-browser split
│   │
│   └── lsp/                           # Native 0.12 server definitions (cmd, filetypes, roots)
│       ├── lua_ls.lua                 # Lua language server configuration
│       ├── gopls.lua                  # Go language server configuration
│       ├── rust_analyzer.lua          # Rust language server configuration
│       ├── ts_ls.lua                  # TypeScript/JavaScript language server
│       ├── tinymist.lua               # Typst language server
│       └── marksman.lua               # Markdown language server (with backlink support)
```

---

## 3. Core Subsystems Specification

### 3.1 Bootstrap & Loader (`init.lua` & `lua/pack/init.lua`)

- **`init.lua`**:
  1. Sets `vim.g.mapleader = " "` and `vim.g.maplocalleader = " "`.
  2. Requires `"core"` (loads options, vanilla keymaps, autocmds, and native
     statusline).
  3. Requires `"pack"` (triggers the native package manager discovery and
     initialization).
- **`lua/pack/init.lua`**:
  - Discovers all Lua files under `lua/plugins/**/*.lua`.
  - Normalizes each returned table spec:
    - `src`: Git repository URL or GitHub slug (`owner/repo`).
    - `build`: Optional shell command run on install/update via `PackChanged`.
    - `event`, `ft`, `cmd`, `keys`: Lazy triggers.
    - `config`: Function executed once the plugin runtimepath is sourced.
  - Passes all specs to `vim.pack.add(specs, { load = false })` to register with
    Neovim.
  - Automatically loads startup plugins
    (`event == nil and ft == nil and cmd == nil and keys == nil`) and executes
    their `config()`.
  - Attaches single-shot `nvim_create_autocmd` handlers or user-command stubs
    for lazy plugins that call `vim.cmd.packadd(name)` and run `config()`.

### 3.2 Decoupled Core (`lua/core/`)

- **`options.lua`**:
  - Preserves standard editor preferences (`relativenumber`,
    `clipboard = "unnamed,unnamedplus"`, `scrolloff = 16`, `undofile = true`,
    `termguicolors = true`).
  - Sets `foldmethod = "manual"` by default to ensure 100% decoupling from
    Treesitter until a buffer-specific parser attaches.
- **`keymaps.lua`**:
  - Basic window navigation (`<C-w>h/j/k/l`), clearing search highlights
    (`<Esc>`), and terminal escape bindings.
- **`autocmds.lua`**:
  - Native `TextYankPost` highlight event (`vim.hl.on_yank({ timeout = 200 })`).
- **`statusline.lua`**:
  - 100% native Lua statusline (0 external dependencies).
  - Dynamically computes Mode (`N`, `I`, `V`), relative file path, modified
    flag, Git diff status, and active LSP servers.
  - Solves the LSP synchronization issue using a dedicated `autocmd` on
    `LspAttach`, `LspDetach`, and `DiagnosticChanged` that calls
    `vim.cmd.redrawstatus()`.

### 3.3 Buffer Filetype Hooks (`ftplugin/`)

- **`ftplugin/markdown.lua`**:
  - `vim.opt_local.textwidth = 80`
  - Attaches `BufWritePre` hook for `TableTidyAll`.
- **`ftplugin/go.lua` & `ftplugin/rust.lua`**:
  - `vim.opt_local.textwidth = 80`
  - `vim.opt_local.formatoptions:append("cqro")`

---

## 4. Plugin Inventory & Detailed Specifications

### 4.1 UI Plugins (`lua/plugins/ui/`)

1. **`colorscheme.lua`**:
   - **Repository**: `aktersnurra/no-clown-fiesta.nvim`
   - **Trigger**: Startup (`priority = 1000`)
   - **Details**: Loads dark theme with transparent background. Defines a
     persistent `ColorScheme` autocmd setting `SnacksIndent` to `#444444` (thin
     line) and `SnacksIndentScope` with higher contrast (thicker active scope),
     preserving the visual hierarchy across colorscheme resets.
2. **`which-key.lua`**:
   - **Repository**: `folke/which-key.nvim`
   - **Trigger**: `event = "UIEnter"`
   - **Details**: Modern preset with icon separators. Provides a global safe
     helper function `safe_wk_add(spec)` wrapped in a
     `pcall(require, "which-key")` so that other plugin files can register keys
     safely without failing if `which-key` is disabled.

### 4.2 System Tools & Git (`lua/plugins/tools/`)

1. **`snacks.lua`**:
   - **Repository**: `folke/snacks.nvim`
   - **Trigger**: Startup (`priority = 1000`)
   - **Modules Enabled**:
     - `picker`: Replaces Telescope; smart files, grep, buffer search,
       notification history.
     - `explorer`: Clean tree navigation.
     - `indent`: Renders smooth vertical guides and animated scope lines.
     - `bufdelete`: Safely closes buffers without closing window splits.
     - `git`: Repository-level pickers (`<leader>gl` for commit log,
       `<leader>gs` for git status, `<leader>gS` for branches).
   - **Modules Disabled**: `input = { enabled = false }` (preserves native
     bottom command line prompt), `notifier = { enabled = false }` (preserves
     subtle `fidget.nvim`).
2. **`gitsigns.lua`**:
   - **Repository**: `lewis6991/gitsigns.nvim`
   - **Trigger**: `event = { "BufReadPre", "BufNewFile" }`
   - **Details**: Manages in-buffer git gutter diff signs (`+`, `~`, `-`),
     inline hunk previews (`<leader>hp`), hunk staging (`<leader>hs`), hunk
     resetting (`<leader>hr`), and inline line blame (`<leader>gb`).

### 4.3 Coding Stack (`lua/plugins/coding/`)

#### Syntax & Mechanics (`lua/plugins/coding/syntax/`)

1. **`treesitter.lua`**:
   - **Repository**: `nvim-treesitter/nvim-treesitter` (main branch)
   - **Trigger**: `event = { "BufReadPre", "BufNewFile" }`
   - **Details**: Lean parser installer and query provider. Configures
     buffer-local Treesitter folding (`vim.opt_local.foldmethod = "expr"`,
     `vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"`) only when a
     parser successfully attaches.
2. **`textobjects.lua`**:
   - **Repository**: `nvim-treesitter/nvim-treesitter-textobjects`
   - **Trigger**: Loaded alongside Treesitter
   - **Details**: Provides semantic AST text-objects: `af`/`if` for function
     outer/inner, `aa`/`ia` for parameter outer/inner, and `]m`/`[m` motions to
     jump between functions.
3. **`autotag.lua`**:
   - **Repository**: `windwp/nvim-ts-autotag`
   - **Trigger**: `event = "InsertEnter"`
   - **Details**: Auto-closes and auto-renames HTML/JSX/TSX/XML tags
     synchronously.
4. **`completion.lua`**:
   - **Repository**: `saghen/blink.cmp`
   - **Trigger**: `event = "InsertEnter"`
   - **Build**: Automated prebuilt release binary download or
     `cargo build --release`.
   - **Details**: High-performance Rust fuzzy completion engine with snippet
     expansion, rounded border popup menus, and first-class `lazydev` library
     source integration.
5. **`autopairs.lua`**:
   - **Repository**: `echasnovski/mini.pairs`
   - **Trigger**: `event = "InsertEnter"`
   - **Details**: Lightweight (~200 lines of pure Lua) auto-pairing of brackets,
     parentheses, and quotes.
6. **`surround.lua`**:
   - **Repository**: `kylechui/nvim-surround`
   - **Trigger**: `event = { "BufReadPre", "BufNewFile" }`
   - **Details**: Classic `ys`, `cs`, and `ds` surround grammar. Preserves
     instantaneous normal-mode `s` substitute execution without timeout
     hesitation.
7. **`formatting.lua`**:
   - **Repository**: `stevearc/conform.nvim`
   - **Trigger**: `event = { "BufReadPre", "BufNewFile" }`
   - **Details**: Asynchronous formatter on save with LSP fallback. Configures
     `stylua`, `gofumpt`, `golines`, `rustfmt`, `prettier`, and `kulala-fmt`.

#### LSP Ecosystem (`lua/plugins/coding/lsp/`)

1. **`lsp.lua`**:
   - **Trigger**: Startup (`event = { "BufReadPre", "BufNewFile" }`)
   - **Details**:
     - Attaches `blink.cmp` capabilities to all servers via
       `vim.lsp.config('*', { capabilities = ... })`.
     - Sets standard diagnostic appearance (single float borders, current-line
       virtual lines).
     - Activates servers:
       `vim.lsp.enable({ "lua_ls", "gopls", "rust_analyzer", "ts_ls", "tinymist", "marksman" })`.
2. **`lazydev.lua`**:
   - **Repository**: `folke/lazydev.nvim`
   - **Trigger**: `ft = "lua"`
   - **Details**: Pre-indexes Neovim C/Lua runtime APIs, luvit types
     (`${3rd}/luv/library`), and plugin libraries (`snacks.nvim`,
     `which-key.nvim`) to provide comprehensive autocompletion and diagnostics
     when editing configuration.
3. **`fidget.lua`**:
   - **Repository**: `j-hui/fidget.nvim`
   - **Trigger**: `event = "LspAttach"`
   - **Details**: Unobtrusive, subtle LSP indexing and progress notifications in
     the bottom right corner.
4. **`trouble.lua`**:
   - **Repository**: `folke/trouble.nvim`
   - **Trigger**: `cmd = "Trouble"`
   - **Details**: Diagnostics list and quickfix provider. Implements the custom
     **dual tree-based section backlink viewer** (integrated for both `Trouble`
     and `Snacks.picker`), querying Marksman for all incoming links to any
     heading in the active Markdown document and grouping results by section
     anchor.

#### Debug, Test & REST (`lua/plugins/coding/debug/`)

1. **`kulala.lua`**:
   - **Repository**: `mistweaverco/kulala.nvim`
   - **Trigger**: `ft = { "http", "rest" }`
   - **Details**: Interactive REST client for sending HTTP requests directly
     from `.http` files (`<leader>rs`).
2. **`neotest.lua`**:
   - **Repository**: `nvim-neotest/neotest`
   - **Dependencies**: `nvim-neotest/nvim-nio`
   - **Trigger**: `cmd = "Neotest"` or test keymap (`<leader>tr`)
   - **Details**: Unified test runner framework supporting Go (`neotest-go`) and
     Rust test discovery.
3. **`dap.lua`**:
   - **Repository**: `mfussenegger/nvim-dap`
   - **Trigger**: `keys = { "<F5>", "<leader>db" }`
   - **Details**: Debug Adapter Protocol engine with LLDB configuration for
     compiling and debugging Rust and Zig executables.
4. **`dap-ui.lua`**:
   - **Repository**: `rcarriga/nvim-dap-ui`
   - **Dependencies**: `nvim-neotest/nvim-nio`
   - **Trigger**: Loaded automatically on DAP start/stop events.
   - **Details**: Split windows for stacks, watches, breakpoints, and scopes.
5. **`dap-go.lua`**:
   - **Repository**: `leoluz/nvim-dap-go`
   - **Trigger**: `ft = "go"`
   - **Details**: Automatically configures Delve (`dlv`) debug adapter for Go
     packages and tests.

### 4.4 Notes & Documentation (`lua/plugins/notes/`)

1. **`bullets.lua`**:
   - **Repository**: `bullets-vim/bullets.nvim`
   - **Trigger**: `ft = { "markdown", "text", "gitcommit" }`
   - **Details**: Pure Lua list automation: auto-continues bullet points on
     `<Enter>`, auto-renumbers numbered lists on edit, adjusts indentation
     levels on `<C-t>`/`<C-d>`, and toggles checkboxes with `<leader>x`.
2. **`render-markdown.lua`**:
   - **Repository**: `MeanderingProgrammer/render-markdown.nvim`
   - **Trigger**: `ft = { "markdown" }`
   - **Details**: Cosmetic in-buffer rendering using Treesitter extmarks.
     Renders icons for headings, pretty checkbox states, callout blocks, and
     unicode table borders.
3. **`yamlmatter.lua`**:
   - **Repository**: `ray-x/yamlmatter.nvim`
   - **Trigger**: `ft = { "markdown" }`
   - **Details**: Visual enhancer for YAML frontmatter headers. Aligns metadata
     fields and replaces raw keys with Nerd Font glyphs (`title`, `author`,
     `date`, `tags`, AI prompt headers).
4. **`table-tidy.lua`**:
   - **Repository**: `timantipov/md-table-tidy.nvim`
   - **Trigger**: `cmd = "TableTidyAll"`
   - **Details**: Formats and cleans markdown tables, aligning pipe columns
     cleanly.
5. **`preview.lua`**:
   - **Repository**: `iamcco/markdown-preview.nvim`
   - **Trigger**: `cmd = { "MarkdownPreviewToggle", "MarkdownPreview" }`,
     `ft = "markdown"`
   - **Build**: `cd app && bun install`
   - **Details**: Bound to `<C-p>`. Configures
     `vim.g.mkdp_browserfunc = "v:lua.OpenInSplit"` to spawn `terminal-browser`
     inside a native vertical split
     (`:vsplit | terminal terminal-browser <url>`), providing in-terminal live
     markdown previews.

---

## 5. Native Language Server Definitions (`lsp/*.lua`)

Neovim 0.12 natively loads definitions placed under
`'runtimepath'/lsp/<server>.lua`:

1. **`lsp/lua_ls.lua`**:
   - Spawns `lua-language-server`.
   - Filetypes: `{"lua"}`.
   - Root markers: `{ ".luarc.json", ".luarc.jsonc", ".git" }`.
2. **`lsp/gopls.lua`**:
   - Spawns `gopls`.
   - Filetypes: `{"go", "gomod", "gowork"}`.
   - Root markers: `{ "go.work", "go.mod", ".git" }`.
   - Settings: `completeUnimported = true`, `usePlaceholders = true`,
     `unusedparams = true`.
3. **`lsp/rust_analyzer.lua`**:
   - Spawns `rust-analyzer`.
   - Filetypes: `{"rust"}`.
   - Root markers: `{ "Cargo.toml", ".git" }`.
4. **`lsp/ts_ls.lua`**:
   - Spawns `typescript-language-server --stdio`.
   - Filetypes:
     `{"javascript", "javascriptreact", "typescript", "typescriptreact"}`.
   - Root markers:
     `{ "tsconfig.json", "package.json", "jsconfig.json", ".git" }`.
5. **`lsp/tinymist.lua`**:
   - Spawns `tinymist`.
   - Filetypes: `{"typst"}`.
   - Root markers: `{ "typst.toml", ".git" }`.
6. **`lsp/marksman.lua`**:
   - Spawns `marksman server`.
   - Filetypes: `{"markdown"}`.
   - Root markers: `{ ".marksman.toml", ".git" }`.
   - Disables `completionProvider = false` to let `blink.cmp` provide
     snippet/path completions while Marksman powers link diagnostics, headings,
     and cross-file backlinks.

---

## 6. Deprecation & Pruning Record

The following components from the previous configuration
(`~/.dotfiles/nvim/.config/nvim`) were deliberately dropped:

| Dropped Component                    | Motivation & Replacement                                                                                  |
| :----------------------------------- | :-------------------------------------------------------------------------------------------------------- |
| **`lazy.nvim`**                      | Replaced by Neovim 0.12 native `vim.pack` (zero startup overhead, native lockfile).                       |
| **`nvim-lspconfig`**                 | Obsolete in 0.12; replaced by native `lsp/<server>.lua` auto-discovery and `vim.lsp.enable()`.            |
| **`rebelot/heirline.nvim`**          | Replaced by a 60-line native Lua statusline with `redrawstatus` event synchronization.                    |
| **`Neogit` & `diffview.nvim`**       | Dropped to eliminate heavy dependencies (`plenary`, `diffview`); `gitsigns` handles buffer diffs/staging. |
| **`octo.nvim`**                      | Dropped to remove `telescope.nvim` and `plenary.nvim` dependencies.                                       |
| **`christoomey/vim-tmux-navigator`** | Dropped; migrating to `herdr`.                                                                            |
| **`opencode.nvim` & `omp.nvim`**     | Removed from active editor startup.                                                                       |
| **`obsidian.nvim` & `zk.lua`**       | Dropped; migrating knowledge management to `nvim-orgmode` & `org-roam.nvim`.                              |
| **`hyprls.lua`**                     | Obsolete; Hyprland configuration migrated to Lua.                                                         |
| **`windwp/nvim-autopairs`**          | Replaced by minimal `echasnovski/mini.pairs`.                                                             |
| **`surf` browser**                   | Replaced by `terminal-browser-bin` running in an internal Neovim split via `mkdp_browserfunc`.            |

---

## 7. External System Prerequisites

For this configuration to be fully functional on a clean system, install the
following external binaries, toolchains, language servers, and formatters.

### 7.1 Core System Tools

| Requirement                                    | Purpose                          | Notes                                                                                                                                                                 |
| :--------------------------------------------- | :------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Neovim $\ge$ 0.12.0**                        | Core editor runtime              | Required for native `vim.pack` package management and `lsp/<server>.lua` auto-discovery.                                                                              |
| **Git**                                        | Package cloning & updates        | Required by `vim.pack` and `gitsigns.nvim`.                                                                                                                           |
| **`tree-sitter` CLI** (`tree-sitter-cli`)      | Parser generation & compilation  | Required by `nvim-treesitter` (main branch) to compile and build AST grammar `.so` shared libraries (`pacman -S tree-sitter-cli` or `cargo install tree-sitter-cli`). |
| **C / C++ Compiler** (`gcc`, `clang`, or MSVC) | Tree-sitter parser compilation   | Required by `nvim-treesitter` and `tree-sitter` CLI to compile C/C++ grammar sources.                                                                                 |
| **`make`**                                     | Build automation                 | Used across native parser build steps.                                                                                                                                |
| **Nerd Font**                                  | Terminal glyph rendering         | Required for file icons, mode badges, indent scope, and `yamlmatter` / `which-key` icons (e.g. _JetBrains Mono Nerd Font_).                                           |
| **Clipboard Tool**                             | System clipboard synchronization | Depends on display server: `wl-copy`/`wl-paste` (Wayland), `xclip`/`xsel` (X11), `pbcopy`/`pbpaste` (macOS), or `clip.exe` (WSL).                                     |

### 7.2 Language Runtimes & Package Managers

| Runtime                               | Purpose in this Configuration                                                                                                                                                                                                 |
| :------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Rust Toolchain** (`cargo`, `rustc`) | • Compiling native Rust fuzzy matcher for `blink.cmp` (`cargo build --release`).<br>• Compiling projects for debugging via LLDB.<br>• Managing `rust-analyzer` and `rustfmt`.                                                 |
| **Go** (`go`)                         | Go development, test running via `neotest`, and managing `gopls` / `dlv`.                                                                                                                                                     |
| **Bun** (`bun`)                       | • Complete replacement for Node.js & npm.<br>• Installs and runs global CLI tools (`bun install -g typescript-language-server prettier`).<br>• Post-install build step for `markdown-preview.nvim` (`cd app && bun install`). |

### 7.3 Language Server Protocol (LSP) Daemons

Declared in `lsp/*.lua` and auto-started via `vim.lsp.enable()`:

| Server Binary                    | Configuration File      | Target Language                | Typical Install Command                                |
| :------------------------------- | :---------------------- | :----------------------------- | :----------------------------------------------------- |
| **`lua-language-server`**        | `lsp/lua_ls.lua`        | Lua & Neovim config            | System package manager or GitHub release binary        |
| **`gopls`**                      | `lsp/gopls.lua`         | Go                             | `go install golang.org/x/tools/gopls@latest`           |
| **`rust-analyzer`**              | `lsp/rust_analyzer.lua` | Rust                           | `rustup component add rust-analyzer`                   |
| **`typescript-language-server`** | `lsp/ts_ls.lua`         | TypeScript, JavaScript         | `bun install -g typescript typescript-language-server` |
| **`tinymist`**                   | `lsp/tinymist.lua`      | Typst markup                   | `cargo install --locked tinymist` or system package    |
| **`marksman`**                   | `lsp/marksman.lua`      | Markdown (backlinks & anchors) | System package manager or GitHub release binary        |

### 7.4 Code Formatters (used by `conform.nvim`)

Declared in `lua/plugins/coding/syntax/formatting.lua`:

| Formatter Binary | Target Filetype                        | Typical Install Command                                   |
| :--------------- | :------------------------------------- | :-------------------------------------------------------- |
| **`stylua`**     | Lua (`.lua`)                           | `cargo install stylua` or system package                  |
| **`rustfmt`**    | Rust (`.rs`)                           | `rustup component add rustfmt`                            |
| **`gofumpt`**    | Go (`.go`)                             | `go install mvdan.cc/gofumpt@latest`                      |
| **`prettier`**   | JS/TS, CSS, HTML, JSON, YAML, Markdown | `bun install -g prettier`                                 |
| **`tombi`**      | TOML (`.toml`)                         | `cargo install tombi` or system package                   |
| **`kulala-fmt`** | HTTP / REST (`.http`, `.rest`)         | Bundled with `kulala.nvim` or `bun install -g kulala-fmt` |

### 7.5 Debug Adapters (DAP)

Declared in `lua/plugins/coding/debug/`:

| Debugger Binary   | Config File  | Target Ecosystem  | Typical Install Method                                |
| :---------------- | :----------- | :---------------- | :---------------------------------------------------- |
| **`lldb-dap`**    | `dap.lua`    | Rust, Zig, C, C++ | Part of system LLVM / Clang / LLDB packages           |
| **`dlv`** (Delve) | `dap-go.lua` | Go                | `go install github.com/go-delve/delve/cmd/dlv@latest` |

### 7.6 Specialized Viewers

| Tool Binary            | Config File                     | Purpose                         | Notes                                                                                                                            |
| :--------------------- | :------------------------------ | :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------- |
| **`terminal-browser`** | `lua/plugins/notes/preview.lua` | In-editor Markdown HTML preview | Runs inside a vertical Neovim split via `markdown-preview.nvim`. Available on AUR (`terminal-browser-bin`) or upstream releases. |
