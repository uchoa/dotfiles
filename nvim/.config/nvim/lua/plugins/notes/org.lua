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
				roam = {
					directory = "~/.notebook",
					capture_templates = {
						d = {
							description = "default",
							type = "plain",
							template = "%?",
							target = "%<%Y%m%d%H%M%S>-${slug}.org",
							head = "#+TITLE: ${title}\n",
							unnarrowed = true,
						},
					},
					dailies = {
						capture_templates = {
							d = {
								description = "default",
								type = "entry",
								template = "* %?",
								target = "%<%Y-%m-%d>.org",
								head = "#+TITLE: %<%Y-%m-%d>\n",
							},
						},
					},
					capture_ref_templates = {
						r = {
							description = "ref",
							type = "plain",
							template = "%?",
							target = "${slug}.org",
							head = "#+TITLE: ${title}\n#+ROAM_REFS: ${ref}\n",
							unnarrowed = true,
						},
					},
				},
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
				kanban = {
					columns = {
						"TODO",
						{ "NEXT", "WAITING", name = "DOING", wip = 3 },
						"DONE",
					},
				},
				review = {},
				heatmap = { weeks = 52 },
				sidebar = { position = "right" },
				lsp = {},
				cli = { install_dir = "~/.local/bin" },
			},
			babel = {
				uppercase_example_markers = true,
			},
			structure_template_alist = {
				s = "SRC",
				e = "EXAMPLE",
				q = "QUOTE",
				c = "CENTER",
				C = "COMMENT",
				l = "EXPORT latex",
				h = "EXPORT html",
				a = "EXPORT ascii",
				v = "VERSE",
			},
			tempo_keywords = {
				L = "LATEX",
				H = "HTML",
				A = "ASCII",
				i = "INDEX",
			},
		})

		local completion = require("org.completion")
		local orig_get = completion.get
		completion.get = function(line, col, bufnr)
			local ctx = orig_get(line, col, bufnr)
			if ctx and ctx.items then
				for _, item in ipairs(ctx.items) do
					if item.kind == "keyword" and item.word then
						item.word = item.word:upper()
						if item.abbr then
							item.abbr = item.abbr:upper()
						end
						if item.label then
							item.label = item.label:upper()
						end
					end
				end
			end
			return ctx
		end

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.org",
			group = vim.api.nvim_create_augroup("OrgUppercaseKeywords", { clear = true }),
			callback = function(args)
				local ok, kw = pcall(require, "org.keywords")
				if not ok then
					return
				end

				local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
				local entries = kw.collect(lines)
				local changed = false

				for _, entry in ipairs(entries) do
					local line = lines[entry.line]
					local prefix, rest = line:match("^(%s*#%+)[%w_%-]+(:.*)$")
					if prefix then
						local expected = prefix .. entry.key .. rest
						if line ~= expected then
							lines[entry.line] = expected
							changed = true
						end
					end
				end

				if changed then
					vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
				end
			end,
		})
	end,
}
