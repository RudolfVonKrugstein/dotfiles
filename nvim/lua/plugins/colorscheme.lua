vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
require("tokyonight").setup({
  on_highlights = function(hl, colors)
    hl.Comments = {
      fg = "#737aa2", -- brighter than default, still palette-native
      italic = false,
    }
    hl.DiagnosticUnnecessary = {
      fg = colors.red1,
    }
  end,
})
vim.cmd.colorscheme("tokyonight-night")
