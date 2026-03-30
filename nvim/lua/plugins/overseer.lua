vim.pack.add({ "https://github.com/stevearc/overseer.nvim" })

require("overseer").setup()
vim.keymap.set({ "n" }, "<leader>or", "<cmd>OverseerRun<CR>", { desc = "Run Task" })
vim.keymap.set({ "n" }, "<leader>oo", "<cmd>OverseerOpen<CR>", { desc = "Open Overseer" })
