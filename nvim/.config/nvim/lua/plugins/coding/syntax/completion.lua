return {
  src = "https://github.com/saghen/blink.cmp",
  event = "InsertEnter",
  build = function()
    require("blink.cmp").build():pwait()
  end,
  config = function()
    require("blink.cmp").setup({
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
      signature = { window = { border = "rounded" } },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    })
  end,
}