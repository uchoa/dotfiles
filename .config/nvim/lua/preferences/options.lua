-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set highlight on search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Set fold settings
-- These options where recommended by nvim-ufo
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Tab size configuration
vim.opt.tabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Enable break indent
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.wo.linebreak = true

-- Keep some context around the cursor
vim.opt.scrolloff = 8

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true
