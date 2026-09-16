return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup({})
    
    local ts = require("nvim-treesitter")

    local function register_custom_parsers()
      local ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if ok and type(parsers) == "table" and not parsers.org then
        parsers.org = {
          install_info = {
            url = "https://github.com/nvim-orgmode/tree-sitter-org",
            files = { "src/parser.c", "src/scanner.c" },
          },
          tier = 2,
        }
      end
    end

    register_custom_parsers()
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = register_custom_parsers,
      desc = "Register custom tree-sitter parsers",
    })

    -- Auto-install missing parsers on-demand when opening an uninstalled filetype,
    -- and activate native syntax highlighting + foldexpr once the parser is ready.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local filetype = vim.bo[args.buf].filetype
        local buftype = vim.bo[args.buf].buftype
        if filetype == "" or buftype ~= "" or filetype:match("^blink%-cmp") then return end

        local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
        if not (ok and parser) then
          local lang = vim.treesitter.language.get_lang(filetype) or filetype
          local available = ts.get_available()
          local installed = ts.get_installed()

          if vim.list_contains(available, lang) and not vim.list_contains(installed, lang) then
            pcall(ts.install, lang)
            ok, parser = pcall(vim.treesitter.get_parser, args.buf)
          end
        end

        if ok and parser then
          pcall(vim.treesitter.start, args.buf)
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}