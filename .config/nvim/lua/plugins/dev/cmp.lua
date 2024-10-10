return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		'hrsh7th/cmp-buffer', -- source for text in buffer
		'hrsh7th/cmp-path',   -- source for file system paths
		{
			'L3MON4D3/LuaSnip',
			-- follow latest release
			version = 'v2.*',
			-- install jsregexp (optionsl)
			build = 'make install_jsregexp',
		},
		'saadparwaiz1/cmp_luasnip', -- for autocompletion
		'rafamadriz/friendly-snippets', -- useful snippets
		'onsails/lspkind.nvim' -- adds pictograms to completion
	},
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		local lspkind = require('lspkind')
		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require('luasnip.loaders.from_vscode').lazy_load()

		cmp.setup({
			completion = {
				completeopt = 'menu,menuone,preview,noselect',
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<CR>'] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
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
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' }, -- neovim lsp
				{ name = 'luasnip' }, -- snippets
				{ name = 'buffer' }, -- text within current buffer
				{ name = 'path' }, -- file system paths
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			-- configure lspkind for pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					-- defines how annotations are shown
					-- default: symbol
					-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
					mode = 'symbol_text',
					maxwidth = 50,
					ellipsis_char = '...',
					show_labelDetails = true,
				}),
			},
		})
	end,
}
