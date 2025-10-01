return {
  "oribarilan/lensline.nvim",
  branch = "release/2.x", -- or: branch = 'release/2.x' for latest non-breaking updates
  event = "LspAttach",
  config = function()
    require("lensline").setup()
  end,
}
