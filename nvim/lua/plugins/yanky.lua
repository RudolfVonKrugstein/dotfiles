vim.pack.add({
  "http://github.com/folke/snacks.nvim",
  "https://github.com/gbprod/yanky.nvim",
})
require("yanky").setup({
  highlight = { timer = 300 },
  ring = {
    update_register_on_cycle = true,
  },
})
vim.keymap.set({ "n", "x" }, "<leader>p", function()
  Snacks.picker.yanky()
end, { desc = "Open Yank History" })
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank Text" })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
vim.keymap.set("n", "[y", "<Plug>(YankyCycleForward)", { desc = "Cycle Forward Through Yank History" })
vim.keymap.set("n", "]y", "<Plug>(YankyCycleBackward)", { desc = "Cycle Backward Through Yank History" })
