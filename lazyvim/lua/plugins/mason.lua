return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "prettier",

        -- python stuff
        "debugpy",
        "ruff",
        "basedpyright",
        -- "python-lsp-server",
      },
    },
  },
}
