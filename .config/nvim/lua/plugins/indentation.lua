return {
	{
		-- Add indentation lines even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {
			indent = {
        char = "▏",
        -- tab_char = "│",
				smart_indent_cap = true,
				repeat_linebreak = true,
      },
      -- scope = { show_start = false, show_end = false },
			scope = { enabled = false },
      exclude = {
        filetypes = {
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
      },
		}
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
	},
}
