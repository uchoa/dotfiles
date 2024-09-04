return {
	{ 'nvim-tree/nvim-web-devicons' },

	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			options = {
				icons_enabled = true,
				--theme = 'auto',
				-- component_separators = '|',
				theme = 'visual_studio_code',
				component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        globalstatus = true,
        refresh = {
            statusline = 100,
        },
			},
			sections = require('visual_studio_code').get_lualine_sections(),
		},
	},

	{
		'folke/which-key.nvim',
		opts = {},
		config = function()
			local wk = require('which-key')
			wk.add({
				{ '<leader>', group = 'VISUAL <leader>' },
				{ '<leader>b', group = 'buffer' },
				{ '<leader>b_', hidden = true },
				{ '<leader>g', group = 'git' },
				{ '<leader>g_', hidden = true },
				{ '<leader>s', group = 'search' },
				{ '<leader>s_', hidden = true },
				{ '<leader>h', group = 'git hunk' },
				{ '<leader>h_', hidden = true },
				{ '<leader>w', group = 'workspace' },
				{ '<leader>w_', hidden = true },
				{ '<leader>o', group = 'org mode' },
				{ '<leader>o_', hidden = true },
				{ '<leader>n', group = 'notes (org roam)' },
				{ '<leader>n_', hidden = true },
			})
		end
	},
}
