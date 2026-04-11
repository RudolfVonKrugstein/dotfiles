-- Close specific window types with 'q'
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help", "netrw", "toggleterm", "neo-tree" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
  end,
})
