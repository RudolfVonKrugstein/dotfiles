-- jev.nvim: ask TypeSafe Jev a question about every function in a buffer,
-- results land in the quickfix list ranked by probability.
vim.pack.add({ "https://github.com/valentynkit/jev.nvim" })

-- jev.nvim reads TYPESAFE_API_KEY; fall back to the key file shared with the
-- Jev MCP server (see nixos/home-manager/jev-mcp-activate.nix).
if not vim.env.TYPESAFE_API_KEY or vim.env.TYPESAFE_API_KEY == "" then
  local key_file = vim.fn.expand("~/.config/typesafe/key")
  if vim.fn.filereadable(key_file) == 1 then
    local key = vim.trim(table.concat(vim.fn.readfile(key_file), ""))
    if key ~= "" then
      vim.env.TYPESAFE_API_KEY = key
    end
  end
end

require("jev").setup({})

-- ":Jev " without <CR> so the question can be typed; in visual mode the
-- range ('<,'>) is inserted automatically and limits the run to the selection.
vim.keymap.set({ "n", "x" }, "<leader>jj", ":Jev ", { desc = "Ask Jev about functions" })
vim.keymap.set("n", "<leader>js", "<cmd>JevSort<CR>", { desc = "Sort Jev results" })
vim.keymap.set("n", "<leader>jc", "<cmd>JevClear<CR>", { desc = "Clear Jev results" })
