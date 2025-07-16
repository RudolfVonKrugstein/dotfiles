local is_arm = vim.loop.os_uname().machine == "aarch64"

-- dont use mason for somee lspss ion arm
local servers = {}
if is_arm then
  servers["lua_ls"] = { mason = false }
  servers["erlangls"] = { mason = false }
  servers["nil_ls"] = { mason = false }
  servers["helm_ls"] = { mason = false }
  servers["texlab"] = { mason = false }
end

local util = require("lspconfig.util")
vim.lsp.enable("marksman")
vim.lsp.config("marksman", {
  filetypes = { "markdown", "quarto" },
  root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
})

vim.lsp.enable("basedpyright", true)
vim.lsp.config("basedpyright", {
  single_file_support = true,
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly", -- openFilesOnly, workspace
        typeCheckingMode = "standard",
      },
    },
  },
})

vim.lsp.enable("pyrefly", true)
vim.lsp.enable("pylsp", false)
vim.lsp.config("pylsp", {
  mason = false,
  autostart = false,
})

return {
  "neovim/nvim-lspconfig",
}
