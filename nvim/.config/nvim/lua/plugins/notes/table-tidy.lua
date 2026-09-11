return {
  src = "https://github.com/timantipov/md-table-tidy.nvim",
  cmd = "TableTidyAll",
  config = function()
    require("md-table-tidy").setup({})
  end,
}
