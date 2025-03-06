return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  keys = {
    "<C-w>",
    function()
      require("window-picker").pick_window()
    end,
  },
  config = function()
    require("window-picker").setup({ hint = "floating-big-letter" })
  end,
}
