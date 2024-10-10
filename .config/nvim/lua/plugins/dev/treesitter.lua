return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPre', 'BufNewFile' },
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
		'windwp/nvim-ts-autotag',
	},
	build = ':TSUpdate',
	config = vim.defer_fn(function()
		require('nvim-treesitter.configs').setup {
			ensure_installed = { 'c', 'go', 'lua', 'python', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'html', 'css', 'http', 'gitignore', 'dockerfile', 'yaml', 'markdown', 'markdown_inline' },

			auto_install = true,
			sync_install = false,
			ignore_install = { 'org' },
			modules = {},
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<c-space>',
					node_incremental = '<c-space>',
					scope_incremental = '<c-s>',
					node_decremental = '<M-space>',
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						[']m'] = '@function.outer',
						[']]'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']['] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[['] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[]'] = '@class.outer',
					},
				},
				swap = {
					enable = true,
					swap_next = {
						['<leader>a'] = '@parameter.inner',
					},
					swap_previous = {
						['<leader>A'] = '@parameter.inner',
					},
				},
			},
		}
		-- vim.filetype.add({
		-- 	pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
		-- })
	end, 0)
}
