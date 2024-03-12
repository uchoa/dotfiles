return {
	{ 'nvim-tree/nvim-web-devicons' },

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = '|',
				section_separators = { left = '', right = ''},
			},
		},
	},

	-- Useful plugin to show you pending keybinds.
	{ 
		'folke/which-key.nvim', 
		opts = {},

		config = function()
			-- Document existing key chains
			require('which-key').register {
				['<leader>b'] = { name = 'buffer', _ = 'which_key_ignore' },
				['<leader>g'] = { name = 'git', _ = 'which_key_ignore' },
				['<leader>h'] = { name = 'git hunk', _ = 'which_key_ignore' },
				['<leader>s'] = { name = 'search', _ = 'which_key_ignore' },

				-- register which-key VISUAL mode
				-- required for visual <leader>hs (hunk stage) to work
				['<leader>'] = { name = 'VISUAL <leader>' },
				['<leader>h'] = { 'git hunk' }
			}
		end
	},
}
