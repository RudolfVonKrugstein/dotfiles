return {
  -- plugin: auto-save.nvim
  -- function: auto save changes
  -- src: https://github.com/pocco81/auto-save.nvim
  "okuuva/auto-save.nvim",
  opts = {
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = {},
    },
    debounce_delay = 2000,
  },
}
