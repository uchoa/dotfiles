return {
	-- Autocompletion
	'hrsh7th/nvim-cmp',
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			'L3MON4D3/LuaSnip',
			build = (function()
				-- Build Step is needed for regex support in snippets
				-- This step is not supported in many windows environments
				-- Remove the below condition to re-enable on windows
				if vim.fn.has 'win32' == 1 then
					return
				end
				return 'make install_jsregexp'
			end)(),
		},
		'saadparwaiz1/cmp_luasnip',

		-- Adds LSP completion capabilities
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',

		-- Adds a number of user-friendly snippets
		'rafamadriz/friendly-snippets',

		-- Adds pictograms to completion
		'onsails/lspkind.nvim',
	},
	config = function()

		-- [[ Configure nvim-cmp ]]
		-- See `:help cmp`
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		require('luasnip.loaders.from_vscode').lazy_load()
		luasnip.config.setup {}
		local lspkind = require 'lspkind'

		cmp.setup {
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				format = lspkind.cmp_format({
					mode = 'symbol',  -- show only symbol annotations
					maxwidth = 50,  -- prevent the popup from showing more than provided characters
					-- can also be a function to dynamically calculate max width such as 
					-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
					ellipsis_char = '...',  -- when popup menu exceeds maxwidth, the truncated part would show ellipsis
					show_labelDetails = true,  -- show label details in menu; disbled by default
					-- The function below will be called before any actual modification from lspkind
					-- so that you can provide more controls on popup customization (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
					-- before = function(entry, vim_item)
					--   ...
					--   return vim_item
					-- end
				})
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = {
				completeopt = 'menu,menuone,noinsert',
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
				{ name = 'gopls' },
				{ name = 'orgmode' },
			},
		}
	end
}
