vim.pack.add({
  { src = "https://github.com/jeangiraldoo/codedocs.nvim" },
})

require("codedocs").setup({
  debug = false,
  languages = {
    python = {
      default_style = "google",
    },
  },
  aliases = {
    sh = "bash",
  },
})


