return {
  config = function()
    local configs = { "lua_ls", "gopls", "rust_analyzer", "ts_ls", "tinymist", "marksman" }
    
    local has_blink, blink = pcall(require, "blink.cmp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if has_blink then
      capabilities = blink.get_lsp_capabilities(capabilities)
    end

    -- Diagnostic config
    vim.diagnostic.config({
      virtual_lines = { current_line = true },
      float = { border = "rounded" },
    })
    
    -- Load native configs
    for _, name in ipairs(configs) do
      local ok, cfg = pcall(require, "lsp." .. name)
      if ok then
        cfg.capabilities = vim.tbl_deep_extend("force", capabilities, cfg.capabilities or {})
        vim.lsp.config[name] = cfg
      end
    end

    -- Enable servers
    vim.lsp.enable(configs)

    -- Keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        local function map(mode, lhs, rhs, desc)
          opts.desc = desc
          vim.keymap.set(mode, lhs, rhs, opts)
        end
        map("n", "gd", vim.lsp.buf.definition, "LSP Definition")
        map("n", "gD", vim.lsp.buf.declaration, "LSP Declaration")
        map("n", "gr", vim.lsp.buf.references, "LSP References")
        map("n", "K", function() vim.lsp.buf.hover({ border = "rounded", max_width = 80 }) end, "LSP Hover")
        map("n", "<C-S-K>", vim.lsp.buf.signature_help, "LSP Signature Help")
        map("n", "<leader>crn", vim.lsp.buf.rename, "Code Refactor: Rename")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
        map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "Workspace List Folders")
        if vim.lsp.inlay_hint then
          map("n", "<leader>ch", function()
            local current = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
            vim.lsp.inlay_hint.enable(not current, { bufnr = ev.buf })
          end, "Toggle Inlay Hints")
        end
        map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
      end,
    })
  end,
}
