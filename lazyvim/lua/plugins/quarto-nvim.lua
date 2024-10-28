return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
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
    end,
  },
}
