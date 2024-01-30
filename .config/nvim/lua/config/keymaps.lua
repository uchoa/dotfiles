-- File Management
vim.keymap.set("n", "<leader>fn", vim.cmd.Ex, { desc = "Navigate file manager" })

-- Move selection around
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")
