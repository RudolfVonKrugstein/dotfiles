vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })
require("copilot").setup({
  suggestion = {
    enabled = true,
  },
  panel = {
    enabled = false,
  },
  filetypes = {
    markdown = true,
    help = true,
  },
})

vim.keymap.set({ "n", "i" }, "<A-n>", function()
  require("blink.cmp").hide()
  require("copilot.suggestion").next()
end, { desc = "Next copilot suggestion" })
vim.keymap.set({ "n", "i" }, "<A-p>", function()
  require("blink.cmp").hide()
  require("copilot.suggestion").prev()
end, { desc = "Prev copilot suggestion" })
vim.keymap.set({ "n", "i" }, "<A-y>", function()
  require("copilot.suggestion").accept()
end, { desc = "Prev copilot suggestion" })
vim.keymap.set({ "n", "i" }, "<A-u>", function()
  require("copilot.suggestion").dismiss()
end, { desc = "Prev copilot suggestion" })
