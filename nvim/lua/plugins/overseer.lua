return {
  'stevearc/overseer.nvim',
  config = function()
    require("overseer").setup()
    vim.keymap.set({ "n" }, "<leader>aa", "<cmd>OverseerRun<CR>", { desc = "Run Task" })
    vim.keymap.set({ "n" }, "<leader>ao", "<cmd>OverseerOpen<CR>", { desc = "Open Overseer" })
  end
}
