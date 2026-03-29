return {
	"neovim/nvim-lspconfig",
	init = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "marksman" then
					client.server_capabilities.completionProvider = false
				end
			end,
		})
	end,
}
