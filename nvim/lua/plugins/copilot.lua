vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })
require("copilot").setup({
  suggestion = {
    enabled = false,
  },
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<C-CR>",
      close = "q",
    },
    layout = {
      position = "bottom", -- | top | left | right | bottom |
      ratio = 0.4,
    },
  },
  filetypes = {
    markdown = true,
    help = true,
  },
})
