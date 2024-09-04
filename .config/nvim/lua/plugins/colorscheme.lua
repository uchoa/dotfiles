return {
	'askfiy/visual_studio_code',
	priority = 100,
	config = function ()
		require('visual_studio_code').setup({
			mode = 'dark',
			transparent = true,
		})
		vim.cmd([[colorscheme visual_studio_code]])
	end,
}
