return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
  cmd = "VenvSelect",
  opts = {
    -- Your options go here
    name = { "venv", ".venv" },
    auto_refresh = true,
  },
  event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { "<leader>ce", "<cmd>VenvSelect<cr>" },
    { "<leader>co", "<cmd>VenvSelectCached<cr>" },
  },
}
