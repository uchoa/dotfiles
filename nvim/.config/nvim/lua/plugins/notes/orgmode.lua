local M = {
	src = "https://github.com/nvim-orgmode/orgmode",
}

local configured = false

M.config = function()
	if configured then
		return
	end
	configured = true

	local ok, orgmode = pcall(require, "orgmode")
	if not ok then
		return
	end

	orgmode.setup({
		org_agenda_files = { "~/.org/**/*" },
		org_default_notes_file = "~/.org/refile.org",
		org_startup_folded = "content",
	})

	pcall(vim.lsp.enable, "org")

	local function register_wk()
		if _G.safe_wk_add then
			_G.safe_wk_add({
				{ "<leader>o", group = "orgmode" },
				{
					"<leader>oa",
					function()
						require("orgmode").action("agenda.prompt")
					end,
					desc = "Agenda",
				},
				{
					"<leader>oc",
					function()
						require("orgmode").action("capture.prompt")
					end,
					desc = "Capture",
				},
			})
		end
	end

	register_wk()
	vim.schedule(register_wk)
end

return M
