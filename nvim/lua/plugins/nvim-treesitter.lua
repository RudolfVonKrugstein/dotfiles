return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  config = function()
    require("nvim-treesitter").setup({})
    local languages = {
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
    }
    require("nvim-treesitter").install(languages)

    for _, language in ipairs(languages) do
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { language },
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end
  end,
}
