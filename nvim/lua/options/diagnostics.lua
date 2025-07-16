-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- diagnostics setup
vim.diagnostic.config({
  signs = true,
  underline = true,
  virtual_text = true,
  virtual_lines = false,
  update_in_insert = false,
  float = {
    -- UI.
    header = false,
    border = "rounded",
    focusable = false,
  },
})
