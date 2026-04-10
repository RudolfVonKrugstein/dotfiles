vim.pack.add({
  "https://github.com/zbirenbaum/copilot.lua",
  "https://github.com/giuxtaposition/blink-cmp-copilot",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/saghen/blink.cmp",
})


require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
  keymap = {
    preset = "default",
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = {
      auto_show = false,
      auto_show_delay_ms = 0,
      window = {
        border = "rounded",
      },
    },
    menu = {
      border = "rounded",
      winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
    },
  },
  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
  },
  snippets = { preset = "luasnip" },
  fuzzy = { implementation = "prefer_rust" },
  signature = { enabled = true },
})
