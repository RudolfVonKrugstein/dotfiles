---@brief
---
--- https://github.com/ltex-plus/ltex-ls-plus
---
--- LTeX Language Server: LSP language server for LanguageTool 🔍✔️ with support for LaTeX 🎓, Markdown 📝, and others
---
--- To install, download the latest [release](https://github.com/ltex-plus/ltex-ls-plus) and ensure `ltex-ls-plus` is on your path.
---
--- This server accepts configuration via the `settings` key.
---
--- ```lua
---   settings = {
---     ltex = {
---       language = "en-GB",
---     },
---   },
--- ```
---
--- To support org files or R sweave, users can define a custom filetype autocommand (or use a plugin which defines these filetypes):
---
--- ```lua
--- vim.cmd [[ autocmd BufRead,BufNewFile *.org set filetype=org ]]
--- ```

-- we need ltex extra
vim.pack.add({ "https://github.com/barreiroleo/ltex_extra.nvim" })

-- configure LSP
local language_id_mapping = {
  bib = "bibtex",
  pandoc = "markdown",
  quarto = "markdown",
  plaintex = "tex",
  rnoweb = "rsweave",
  rst = "restructuredtext",
  tex = "latex",
  text = "plaintext",
}

---@type vim.lsp.Config
return {
  cmd = { "ltex-ls-plus" },

  on_attach = function(client, bufnr)
    require("ltex_extra").setup({
      load_langs = { "en-US", "de-DE" },
      init_check = true,
      path = ".ltex",
      log_level = "info",
    })
  end,

  on_init = function(client, _)
    local root_dir = client.root_dir
    if not root_dir then
      return
    end
    local config_file = root_dir .. "/.ltex.json"
    if vim.uv.fs_stat(config_file) then
      local content = vim.fn.readfile(config_file)
      local decoded = vim.json.decode(table.concat(content, "\n"))
      client.settings.ltex = vim.tbl_deep_extend("force", client.settings.ltex or {}, decoded)
      client.notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
  end,

  filetypes = {
    "asciidoc",
    "bib",
    "context",
    "gitcommit",
    "html",
    "markdown",
    "org",
    "pandoc",
    "plaintex",
    "quarto",
    "mail",
    "mdx",
    "rmd",
    "rnoweb",
    "rst",
    "tex",
    "text",
    "typst",
    "xhtml",
    "quarto",
  },

  root_markers = { ".git", ".ltex.json", "_quarto.yml" },
  get_language_id = function(_, filetype)
    return language_id_mapping[filetype] or filetype
  end,
  settings = {
    ltex = {
      enabled = {
        "asciidoc",
        "bib",
        "context",
        "gitcommit",
        "html",
        "markdown",
        "org",
        "pandoc",
        "plaintex",
        "quarto",
        "mail",
        "mdx",
        "rmd",
        "rnoweb",
        "rst",
        "tex",
        "latex",
        "text",
        "typst",
        "xhtml",
        "quarto",
      },
      language = "en-US",
      additionalLanguages = { "de-DE" },
    },
  },

  on_new_config = function(new_config, root_dir)
    local config_file = root_dir .. "/.ltex.json"
    if vim.uv.fs_stat(config_file) then
      local content = vim.fn.readfile(config_file)
      print(content)
      local decoded = vim.json.decode(table.concat(content, "\n"))
      new_config.settings.ltex = vim.tbl_deep_extend("force", new_config.settings.ltex, decoded)
    end
  end,
}
