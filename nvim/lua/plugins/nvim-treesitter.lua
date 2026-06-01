vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").setup({})
local languages = {
  "css",
  "scss",
  "zsh",
  "elm",
  "git_config",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "gitattributes",
  "ninja",
  "dockerfile",
  "rst",
  "jinja",
  "bash",
  "c",
  "diff",
  "html",
  "lua",
  "json",
  "yaml",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
  "python",
  "go",
  "gomod",
  "gowork",
  "gosum",
  "rust",
  "gleam",
  "toml",
  "commonlisp",
  "javascript",
}
require("nvim-treesitter").install(languages)

for _, language in ipairs(languages) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { language },
    callback = function()
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldmethod = "expr"
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldlevel = 99
    end,
  })
end
