return {
	{ 'echasnovski/mini.nvim', version = false },

	{
		'echasnovski/mini.bufremove',
		keys = {
			{
				'<leader>bd',
				function()
					local bd = require('mini.bufremove').delete
					if vim.bo.modified then
						local choice = vi.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
						if choice == 1 then -- Yes
							vim.cmd.write()
							bd(0)
						elseif choice == 2 then -- No
							bd(0, true)
						end
					else
						bd(0)
					end
				end,
				desc = 'delete buffer',
			},
			-- stylua: ignore
			{ 
				'<leader>bD', 
				function()
					require('mini.bufremove').delete(0, true)
				end,
				desc = 'delete buffer (force)',
			},
		},
	},

	{
		'echasnovski/mini.indentscope',
		version = '*',
		opts = {
			symbol = "▏",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function()
					---diagnostic disable-next-line: inject-field
					vim.b.miniindentscope_disabled = true
				end,
			})
		end,
	}
}
