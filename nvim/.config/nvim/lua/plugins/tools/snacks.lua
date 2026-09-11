---@class snacks.picker.projects.Config: snacks.picker.Config
local projectsOpts = {
  finder = "recent_projects",
  format = "file",
  dev = { "~/github" },
  confirm = "load_session",
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile", "go.mod", "go.work" },
  recent = true,
  matcher = {
    frecency = true,
    sort_empty = true,
    cwd_bonus = false,
  },
  sort = { fields = { "score:desc", "idx" } },
  win = {
    preview = { minimal = true },
    input = {
      keys = {
        ["<c-e>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
        ["<c-f>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
        ["<c-g>"] = { { "tcd", "picker_grep" }, mode = { "n", "i" } },
        ["<c-r>"] = { { "tcd", "picker_recent" }, mode = { "n", "i" } },
        ["<c-w>"] = { { "tcd" }, mode = { "n", "i" } },
        ["<c-t>"] = {
          function(picker)
            vim.cmd("tabnew")
            Snacks.notify("New tab opened")
            picker:close()
            Snacks.picker.projects()
          end,
          mode = { "n", "i" },
        },
      },
    },
  },
}

return {
  src = "https://github.com/folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      git = { enabled = true },
      image = {
        enabled = true,
        doc = {
          inline = false,
          render_all = false,
        },
      },
      indent = { enabled = true },
      input = { enabled = false },
      picker = {
        enabled = true,
        exclude = { "node_modules", ".git", ".zk", ".jj" },
        hidden = true,
        ignored = true,
        sources = {
          files = { hidden = true, ignored = true },
          grep = { hidden = true, ignored = true },
        },
      },
      notifier = { enabled = false },
      completion = { accept = { auto_brackets = { enabled = true } } },
      bufdelete = { enabled = true },
      explorer = { enabled = true },
    })

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc })
    end

    -- Top Pickers & Explorer
    map("n", "<leader><space>", function() Snacks.picker.smart() end, "Smart Find Files")
    map("n", "<leader>,", function() Snacks.picker.buffers() end, "Buffers")
    map("n", "<leader>/", function() Snacks.picker.grep() end, "Grep")
    map("n", "<leader>:", function() Snacks.picker.command_history({ layout = "ivy" }) end, "Command History")
    map("n", "<leader>n", function() Snacks.picker.notifications() end, "Notification History")
    map("n", "<leader>e", function() Snacks.explorer() end, "File Explorer")

    -- Find (<leader>f...)
    map("n", "<leader>fb", function() Snacks.picker.buffers() end, "Buffers")
    map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, "Find Config File")
    map("n", "<leader>ff", function() Snacks.picker.files() end, "Find Files")
    map("n", "<leader>fg", function() Snacks.picker.git_files() end, "Find Git Files")
    map("n", "<leader>fp", function() Snacks.picker.projects(projectsOpts) end, "Projects")
    map("n", "<leader>fr", function() Snacks.picker.recent() end, "Recent")

    -- Git Pickers (<leader>g...)
    map("n", "<leader>gB", function() Snacks.gitbrowse() end, "Git Browse")
    map("n", "<leader>gb", function() Snacks.picker.git_branches({ layout = "ivy" }) end, "Git Branches")
    map("n", "<leader>gl", function() Snacks.picker.git_log() end, "Git Log")
    map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, "Git Log Line")
    map("n", "<leader>gs", function() Snacks.picker.git_status() end, "Git Status")
    map("n", "<leader>gS", function() Snacks.picker.git_stash() end, "Git Stash")
    map("n", "<leader>gd", function() Snacks.picker.git_diff() end, "Git Diff (Hunks)")
    map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, "Git Log File")

    -- Search Pickers (<leader>s...)
    map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, "Grep Open Buffers")
    map("n", "<leader>sg", function() Snacks.picker.grep() end, "Grep")
    map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, "Visual selection or word")
    map("n", '<leader>s"', function() Snacks.picker.registers() end, "Registers")
    map("n", "<leader>s/", function() Snacks.picker.search_history() end, "Search History")
    map("n", "<leader>sa", function() Snacks.picker.autocmds() end, "Autocmds")
    map("n", "<leader>sb", function() Snacks.picker.lines() end, "Buffer Lines")
    map("n", "<leader>sc", function() Snacks.picker.command_history() end, "Command History")
    map("n", "<leader>sC", function() Snacks.picker.commands() end, "Commands")
    map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, "Diagnostics")
    map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, "Buffer Diagnostics")
    map("n", "<leader>sh", function() Snacks.picker.help() end, "Help Pages")
    map("n", "<leader>sH", function() Snacks.picker.highlights() end, "Highlights")
    map("n", "<leader>si", function() Snacks.picker.icons() end, "Icons")
    map("n", "<leader>sj", function() Snacks.picker.jumps() end, "Jumps")
    map("n", "<leader>sk", function() Snacks.picker.keymaps() end, "Keymaps")
    map("n", "<leader>sl", function() Snacks.picker.loclist() end, "Location List")
    map("n", "<leader>sm", function() Snacks.picker.marks() end, "Marks")
    map("n", "<leader>sM", function() Snacks.picker.man() end, "Man Pages")
    map("n", "<leader>sp", function() Snacks.picker.lazy() end, "Search for Plugin Spec")
    map("n", "<leader>sq", function() Snacks.picker.qflist() end, "Quickfix List")
    map("n", "<leader>sR", function() Snacks.picker.resume() end, "Resume")
    map("n", "<leader>su", function() Snacks.picker.undo() end, "Undo History")
    map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, "Colorschemes")

    -- LSP Pickers (gd, gr, gI, etc.)
    map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
    map("n", "gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
    map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
    map("n", "gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
    map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
    map("n", "<leader>ss", function() Snacks.picker.lsp_symbols({ layout = "right" }) end, "LSP Symbols")
    map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")

    -- Other utilities
    map("n", "<leader>.", function() Snacks.scratch() end, "Toggle Scratch Buffer")
    map("n", "<leader>S", function() Snacks.scratch.select() end, "Select Scratch Buffer")
    map("n", "<leader>bd", function() Snacks.bufdelete() end, "Delete Buffer")
    map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
    map({ "n", "t" }, "<c-/>", function() Snacks.terminal() end, "Toggle Terminal")
    map({ "n", "t" }, "<c-_>", function() Snacks.terminal() end, "which_key_ignore")

    -- Register Which-Key groups safely if which-key is active
    local ok_wk, wk = pcall(require, "which-key")
    if ok_wk then
      wk.add({
        { "<leader>f", group = "file/find" },
        { "<leader>s", group = "search" },
        { "<leader>g", group = "git" },
      })
    end
  end,
}
