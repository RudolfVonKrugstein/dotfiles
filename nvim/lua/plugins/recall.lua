vim.pack.add({ "https://github.com/fnune/recall.nvim", "https://github.com/mohseenrm/marko.nvim" })

require("recall").setup({})
vim.keymap.set("n", "<leader>ml", require("recall.snacks").pick, { desc = "List marks" })
vim.keymap.set("n", "<leader>mm", "<cmd>RecallToggle<CR>", { desc = "Toggle mark" })
vim.keymap.set("n", "]r", "<cmd>RecallNext<CR>", { desc = "Next mark" })
vim.keymap.set("n", "[r", "<cmd>RecallPrev<CR>", { desc = "Prev mark" })
vim.keymap.set("n", "<leader>mc", function()
  local choice = vim.fn.confirm("Really remove all marks?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd("RecallClear")
    print("all marks removed.")
  else
    print("doing nothing.")
  end
end, { desc = "Delete all marks" })
