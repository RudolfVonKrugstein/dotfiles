vim.pack.add({
  "https://github.com/jmbuhr/otter.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/quarto-dev/quarto-nvim",
})
require("otter").setup({})
require("quarto").setup({
  lspFeatures = {
    enabled = true,
    chunks = "all",
    languages = { "python", "lua", "go", "bash", "html" },
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = { enabled = true },
  },
})
