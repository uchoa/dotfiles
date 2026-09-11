return {
  src = "https://github.com/nvim-neotest/neotest",
  cmd = "Neotest",
  config = function()
    local neotest = require("neotest")
    neotest.setup({
      adapters = {},
    })

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map("<leader>tr", function() neotest.output_panel.clear(); neotest.run.run() end, "Run Nearest Test")
    map("<leader>tR", function() neotest.run.stop() end, "Stop Nearest Test")
    map("<leader>td", function() neotest.output_panel.clear(); neotest.run.run({ suite = false, strategy = "dap" }) end, "Debug Nearest Test")
    map("<leader>tf", function() neotest.output_panel.clear(); neotest.run.run(vim.fn.expand("%")) end, "Run Current File")
    map("<leader>ta", function() neotest.output_panel.clear(); neotest.run.run(vim.fn.getcwd()) end, "Run All Tests in Workspace")
    map("<leader>ts", function() neotest.summary.toggle() end, "Toggle Test Summary")
    map("<leader>to", function() neotest.output_panel.toggle() end, "Toggle Output Panel")
    map("<leader>tc", function() neotest.output_panel.clear() end, "Clear Output Panel")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "go", "rust" },
      callback = function(opts)
        vim.keymap.set("n", "<leader>tm", function()
          neotest.output_panel.clear()
          local marker = vim.bo[opts.buf].filetype == "go" and "go.mod" or "Cargo.toml"
          local root_path = vim.fs.find(marker, { upward = true, path = vim.fn.expand("%:p:h") })[1]
          local target_dir = root_path and vim.fn.fnamemodify(root_path, ":h") or vim.fn.expand("%:p:h")
          neotest.run.run(target_dir)
        end, { buffer = opts.buf, desc = "Run all tests in current module/crate" })
      end,
    })

    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>t", group = "test" },
      })
    end
  end,
}