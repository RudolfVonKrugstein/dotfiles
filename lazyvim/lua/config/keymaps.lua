vim.keymap.set({ "n" }, "<leader>mc", "<cmd>Fidget clear<cr>")
vim.keymap.set({ "n" }, "<leader>mh", "<cmd>Fidget history<cr>")

-- windows
vim.keymap.set({ "n" }, "<leader>ww", function()
  require("window-picker").pick_window({ hint = "floating-big-letter" })
end)
