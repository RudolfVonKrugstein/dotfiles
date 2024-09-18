return {
  "neovim/nvim-lspconfig",
  opts = {
    autoformat = false,
    codelens = { enabled = true },
    inlay_hints = { exclude = { "vue", "lua" } },
  },
}
