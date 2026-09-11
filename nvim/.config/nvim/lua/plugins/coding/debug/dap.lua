return {
  src = "https://github.com/mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map("<F5>", function() dap.continue() end, "Continue")
    map("<F10>", function() dap.step_over() end, "Step Over")
    map("<F11>", function() dap.step_into() end, "Step Into")
    map("<F12>", function() dap.step_out() end, "Step Out")
    map("<leader>db", function() dap.toggle_breakpoint() end, "Toggle Breakpoint")
    map("<leader>dB", function() dap.set_breakpoint() end, "Set Breakpoint")
    map("<leader>dm", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, "Set Log Point")
    map("<leader>dr", function() dap.repl.open() end, "REPL")
    map("<leader>dl", function() dap.run_last() end, "Run Last")

    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>d", group = "debug" },
      })
    end
    -- LLDB Adapter for Zig/Rust
    dap.adapters.lldb = {
      type = "executable",
      command = "lldb-dap",
      name = "lldb",
    }

    -- Rust Configuration
    dap.configurations.rust = {
      {
        name = "Launch Rust Executable",
        type = "lldb",
        request = "launch",
        program = function()
          print("Building Rust project...")
          vim.fn.system("cargo build")
          
          local cwd = vim.fn.getcwd()
          local project_name = vim.fn.fnamemodify(cwd, ":t")
          local default_path = cwd .. "/target/debug/" .. project_name
          
          return vim.fn.input("Path to executable: ", default_path, "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local input = vim.fn.input("Arguments: ")
          return vim.split(input, " ", { trimempty = true })
        end,
      },
    }
  end,
}