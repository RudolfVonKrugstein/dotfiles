return {
  'stevearc/overseer.nvim',
  config = function()
    require("overseer").setup()
    vim.keymap.set({ "n" }, "<leader>or", "<cmd>OverseerRun<CR>", { desc = "Run Task" })
    vim.keymap.set({ "n" }, "<leader>oo", "<cmd>OverseerOpen<CR>", { desc = "Open Overseer" })
  end
}
