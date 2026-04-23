vim.pack.add({ "https://github.com/neovim/nvim-lspconfig", "https://github.com/adoyle-h/lsp-toggle.nvim" })
require("lsp-toggle").setup({ telescope = false })

vim.keymap.set("n", "<leader>cl", "<cmd>ToggleLSP<CR>", { desc = "Toggle LSPs" })
