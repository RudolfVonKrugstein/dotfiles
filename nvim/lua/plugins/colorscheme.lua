vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
local util = require("tokyonight.util")
require("tokyonight").setup({
  on_highlights = function(hl, colors)
    hl.Comment = {
      fg = util.lighten(colors.comment, 0.3), -- brighter than default, still palette-native
      italic = false,
    }
    hl.DiagnosticUnnecessary = {
      bg = "#300000",
      underline = false,
    }
  end,
})
vim.cmd.colorscheme("tokyonight-night")
