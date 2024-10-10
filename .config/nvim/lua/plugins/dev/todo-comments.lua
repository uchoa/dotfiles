return {
	'folke/todo-comments.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local todo = require('todo-comments')
		local keymap = vim.keymap

		keymap.set('n', ']t', function()
			todo.jump_next()
		end, { desc = 'next todo comment' })

		keymap.set('n', '[t', function()
			todo.jump_prev()
		end, { desc = 'previous todo comment' })

		todo.setup()
	end,
}
