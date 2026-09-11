return {
  src = "https://github.com/mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  config = function()
    require("kulala").setup()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>r", group = "rest" },
        { "<leader>rs", function() require("kulala").run() end, desc = "Run request" },
        { "<leader>ra", function() require("kulala").run_all() end, desc = "Run all requests" },
        { "<leader>rb", function() require("kulala").scratchpad() end, desc = "Toggle scratchpad" },
      })
    else
      vim.keymap.set("n", "<leader>rs", function() require("kulala").run() end, { desc = "Run request" })
      vim.keymap.set("n", "<leader>ra", function() require("kulala").run_all() end, { desc = "Run all requests" })
      vim.keymap.set("n", "<leader>rb", function() require("kulala").scratchpad() end, { desc = "Toggle scratchpad" })
    end
  end,
}