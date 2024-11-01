-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"
-- disable transparency
vim.opt.pumblend = 0
-- disable virtual text for tiny-inline-diagnostics
vim.diagnostic.config({ virtual_text = false })
-- dont conceal
vim.opt.conceallevel = 0
-- enable spelling
vim.opt.spell = true
