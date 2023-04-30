local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

-- standard severs
local servers = {"html", "cssls", "clangd", "gopls", "pyright", "tsserver", "terraform_lsp"}
-- no rust-analyzer, we are using rust-tools

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

