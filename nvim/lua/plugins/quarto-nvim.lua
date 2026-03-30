vim.pack.add({
  "https://github.com/jmbuhr/otter.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/quarto-dev/quarto-nvim",
})
require("otter").setup({})
require("quarto").setup({
  lspFeatures = {
    enabled = true,
    languages = { "python", "lua" },
    diagnostics = {
      enabled = true,
      triggers = { "BufWrite" },
    },
    completion = { enabled = true },
  },
})
