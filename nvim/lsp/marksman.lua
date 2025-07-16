local util = require("lspconfig.util")

return {
  filetype = { "markdown", "quarto" },
  root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
}
