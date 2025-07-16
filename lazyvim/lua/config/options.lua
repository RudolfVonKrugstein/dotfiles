-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
-- we set up the lsp ourself, so disable it here
vim.g.lazyvim_python_lsp = nil
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
vim.opt.colorcolumn = "120"
-- absolute line numbers
vim.wo.relativenumber = false
