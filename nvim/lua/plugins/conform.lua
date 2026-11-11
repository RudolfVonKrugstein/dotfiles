vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    return nil
    -- -- Disable "format_on_save lsp_fallback" for languages that don't
    -- -- have a well standardized coding style. You can add additional
    -- -- languages here or re-enable it for the disabled ones.
    -- local disable_filetypes = { c = true, cpp = true }
    -- if disable_filetypes[vim.bo[bufnr].filetype] then
    --   return nil
    -- else
    --   return {
    --     timeout_ms = 500,
    --     lsp_format = "fallback",
    --   }
    --   end
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    go = { "goimports", "gofumpt" },
    sh = { "shfmt" },
    markdown = { "panache-fix", "panache" },
    quarto = { "panache-fix", "panache" },
    rmarkdown = { "panache-fix", "panache" },
    -- Conform can also run multiple formatters sequentially
    python = { "ruff" },
    --
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  formatters = {
    ["panache-fix"] = {
      inherit = false,
      command = "panache",
      args = { "lint", "--fix", "$FILENAME" },
      stdin = false,
      -- lint may exit non-zero when unfixable issues remain
      exit_codes = { 0, 1 },
    },
  },
})

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat  buffer" })
