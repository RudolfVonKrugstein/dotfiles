return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      list = {
        selection = "manual",
      },
      sources = {
        completion = {
          enabled_providers = { "lsp", "path", "snippets", "buffer", "codecompanion" },
        },

        providers = {
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          },
        },
      },
    },
  },
}
