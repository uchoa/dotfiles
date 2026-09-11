local map = vim.keymap.set

-- Window movement (both direct <C-h/j/k/l> and standard <C-w> prefixes)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-w>h", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-w>j", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-w>k", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-w>l", "<C-w>l", { desc = "Move to right window" })
-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
