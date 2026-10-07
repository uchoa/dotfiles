return {
  src = "https://github.com/xheisenbugx/org.nvim",
  config = function()
    require("org").setup({
      org_directory = "~/org",
      agenda_files = { "~/org/**/*.org" },
      default_notes_file = "~/org/refile.org",
    })
  end,
}
