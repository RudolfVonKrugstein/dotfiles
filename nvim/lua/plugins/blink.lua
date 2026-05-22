-- Create an event to build `blink.cmp` with `cargo build --release`.
-- This event should be defined *before* the `vim.pack.add` call
-- so it runs automatically after the plugin is installed.
vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "blink.cmp",
  group = vim.api.nvim_create_augroup("blink_update", { clear = true }),
  callback = function(e)
    if e.data.kind == "update" then
      -- Recommended way to access plugin files inside `PackChanged` event
      -- vim.cmd [[packadd blink.cmp]]
      vim.cmd.packadd({ args = { e.data.spec.name }, bang = false })
      -- Build the plugin from source
      -- vim.cmd [[BlinkCmp build]]
      require("blink.cmp.fuzzy.build").build()
    end
  end,
})

vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/saghen/blink.lib",
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
