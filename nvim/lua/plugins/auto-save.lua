vim.pack.add({
  "https://github.com/okuuva/auto-save.nvim",
})
local as = require("auto-save")
as.setup({
  trigger_events = {
    immediate_save = { "BufLeave", "FocusLost" },
    defer_save = {},
  },
  debounce_delay = 2000,
})
