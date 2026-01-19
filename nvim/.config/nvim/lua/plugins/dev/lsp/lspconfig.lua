--  This function gets run when an LSP connects to a particular buffer.
local function on_attach_wrapper(original_on_attach)
	return function(o, bufnr)
		-- First things first: call received on_attach
		if original_on_attach ~= nil then
			original_on_attach(o, bufnr)
		end

		-- NOTE: Remember that lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself
		-- many times.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local nmap = function(keys, func, desc)
			if desc then
				desc = "LSP: " .. desc
			end

			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
		end

		nmap("<leader>crn", vim.lsp.buf.rename, "code refactor: rename")
		nmap("<leader>ca", vim.lsp.buf.code_action, "code action")

		-- See `:help K` for why this keymap
		nmap("K", function()
			vim.lsp.buf.hover({ border = "rounded", max_width = 80 })
		end, "hover documentation")
		nmap("<C-S-K>", vim.lsp.buf.signature_help, "signature documentation")

		-- Lesser used LSP functionality
		nmap("gD", vim.lsp.buf.declaration, "goto declaration")
		nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "workspace add folder")
		nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "workspace remove folder")
		nmap("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "workspace list folders")

		-- Create a command `:Format` local to the LSP buffer
		vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
			vim.lsp.buf.format()
		end, { desc = "Format current buffer with LSP" })
	end
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
		"b0o/schemastore.nvim",
	},

	config = function()
		-- Specify how the border looks like
		local border = {
			{ "┌", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "┐", "FloatBorder" },
			{ "│", "FloatBorder" },
			{ "┘", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "└", "FloatBorder" },
			{ "│", "FloatBorder" },
		}

		-- Add the border on hover and on signature help popup window
		local td_handlers = {
			["textDocument/hover"] = vim.lsp.buf.hover({ border = border }),
			["textDocument/signatureHelp"] = vim.lsp.buf.signature_help({ border = border }),
		}

		-- Add border to the diagnostic popup window
		vim.diagnostic.config({
			-- virtual_text = {
			-- 	prefix = "■ ", -- Could be '●', '▎', 'x', '■', , 
			-- },
			virtual_lines = {
				current_line = true,
			},
			float = {
				border = "single",
			},
		})

		-- blink-cmp supports additional completion capabilities, so broadcast that to servers
		local blink = require("blink.cmp")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = blink.get_lsp_capabilities(capabilities)

		vim.lsp.config("*", {
			on_attach = on_attach_wrapper(nil),
			capabilities = capabilities,
			handlers = td_handlers,
		})

		vim.lsp.enable("lua_ls")
		vim.lsp.enable("gopls")
		vim.lsp.enable("zls")
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("marksman")
		vim.lsp.enable("zk")
		vim.lsp.enable("hyprls")
		vim.lsp.enable("tinymist")
		vim.lsp.enable("kulala_ls")
	end,
}
