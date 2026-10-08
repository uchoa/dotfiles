return {
	src = "https://github.com/xheisenbugx/org.nvim",
	config = function()
		require("org").setup({
			org_directory = "~/.notebook",
			agenda_files = { "~/.notebook/**/*.org" },
			default_notes_file = "~/.notebook/inbox.org",
			ui = {
				bullets = { "◉", "○", "✸", "✿" }, -- or false
				checkboxes = { " ", "◐", "✓" }, -- or false
				hide_emphasis_markers = false,
				indent_mode = true, -- org-indent-mode
				todo_keyword_faces = { WAITING = ":foreground #e0af68 :weight bold" },
			},
			todo_keywords = { "TODO(t) NEXT(n) WAITING(w@/!) | DONE(d!) CANCELLED(c@)" },
			extensions = {
				roam = { directory = "~/.notebook" },
				quickadd = true,
				super_agenda = {
					groups = {
						{ name = "Today", time_grid = true, date = "today" },
						{ name = "Important", priority = "A" },
						{ name = "Due soon", deadline = "future", order = 2 },
						{ name = "Work", tag = { "work", "office" }, order = 1 },
						{ discard = { tag = "someday" } },
						{ auto_category = true, order = 9 },
					},
				},
				review = {},
				heatmap = { weeks = 52 },
				sidebar = { position = "right" },
				lsp = {},
				cli = { install_dir = "~/.local/bin" },
			},
		})
	end,
}
