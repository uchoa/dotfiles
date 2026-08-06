return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")
		local keymap = vim.keymap

		keymap.set("n", "<F5>", function()
			dap.continue()
		end)
		keymap.set("n", "<F10>", function()
			dap.step_over()
		end)
		keymap.set("n", "<F11>", function()
			dap.step_into()
		end)
		keymap.set("n", "<F12>", function()
			dap.step_out()
		end)
		keymap.set("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, { desc = "toggle breakpoint" })
		keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint()
		end, { desc = "set breakpoint" })
		keymap.set("n", "<leader>dm", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, { desc = "set breakpoint with log message" })
		keymap.set("n", "<leader>dr", function()
			dap.repl.open()
		end, { desc = "REPL" })
		keymap.set("n", "<leader>dl", function()
			dap.run_last()
		end, { desc = "run last" })

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
