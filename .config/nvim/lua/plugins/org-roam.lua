return {
  "chipsenkbeil/org-roam.nvim",
  tag = "0.1.0",
  dependencies = {
    {
      "nvim-orgmode/orgmode",
    },
  },
  config = function()
    require("org-roam").setup({
      directory = "~/notes",
    })
  end
}
