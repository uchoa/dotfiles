local map = vim.keymap.set

-- Standard window movement prefixes (<C-w>h/j/k/l; direct <C-h/j/k/l> handled by nvim-tmux-navigation)
map("n", "<C-w>h", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-w>j", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-w>k", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-w>l", "<C-w>l", { desc = "Move to right window" })
-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
