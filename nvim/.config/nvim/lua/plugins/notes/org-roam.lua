local M = {
  src = "https://github.com/chipsenkbeil/org-roam.nvim",
}

M.config = function()
  -- Ensure orgmode is configured first to satisfy dependency requirements
  local ok_orgmode, orgmode_plugin = pcall(require, "plugins.notes.orgmode")
  if ok_orgmode and type(orgmode_plugin) == "table" and orgmode_plugin.config then
    orgmode_plugin.config()
  end

  local ok, roam = pcall(require, "org-roam")
  if not ok then
    return
  end

  roam.setup({
    directory = "~/.org",
  })

  local function register_wk()
    if _G.safe_wk_add then
      _G.safe_wk_add({
        { "<leader>n", group = "org-roam" },
        {
          "<leader>nf",
          function()
            require("org-roam").api.find_node()
          end,
          desc = "Find Node",
        },
        {
          "<leader>nc",
          function()
            require("org-roam").api.capture_node()
          end,
          desc = "Capture Node",
        },
        {
          "<leader>ni",
          function()
            require("org-roam").api.insert_node()
          end,
          desc = "Insert Node",
        },
        {
          "<leader>nl",
          function()
            require("org-roam").ui.toggle_node_buffer()
          end,
          desc = "Toggle Roam Buffer",
        },
      })
    end
  end

  register_wk()
  vim.schedule(register_wk)
end

return M
