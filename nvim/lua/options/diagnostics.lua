-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "next item in quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "prev item in quickfix" })

vim.keymap.set("n", "]w", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN, wrap = true, float = true })
end, { desc = "next warning" })
vim.keymap.set("n", "[w", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, wrap = true, float = true })
end, { desc = "prev warning" })

vim.keymap.set("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, wrap = true, float = true })
end, { desc = "next error" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, wrap = true, float = true })
end, { desc = "prev error" })

vim.keymap.set("n", "<leader>dd", function()
  local opts = {
    focusable = false,
    scope = "cursor",
    close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
  }
  vim.diagnostic.open_float(nil, opts)
end)

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
