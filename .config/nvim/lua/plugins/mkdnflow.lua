return {
	"jakewvincent/mkdnflow.nvim",
	config = function()
		require('mkdnflow').setup({
			modules = {
				yaml = true,
			},
			perspective = {
				priority = 'root',
				root_tell = '.root',
			},
			mappings = {
				MkdnEnter = {{'i', 'n', 'v'}, '<CR>'} 
			}
		})
	end
}
