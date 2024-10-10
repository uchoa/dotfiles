local keymap = vim.keymap

-- window management
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'split window vertically' })
keymap.set('n', '<leader>ss', '<C-w>s', { desc = 'split window horizontally' })
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'make splits equal size' })
keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'close current window' })
