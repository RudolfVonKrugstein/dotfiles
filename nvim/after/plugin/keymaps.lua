vim.lsp.buf.format()
local g = vim.g
local keymap = vim.keymap.set

-- Space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "

-- code action
keymap("n", "<Leader>a", function()
  vim.lsp.buf.code_action()
end)

-- Word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- telescope
local builtin = require('telescope.builtin')
keymap('n', '<leader>f', builtin.find_files, {})
keymap('n', '<leader>/', builtin.live_grep, {})
keymap('n', '<leader>*', builtin.grep_string, {})
keymap('n', '<leader>b', builtin.buffers, {})
keymap('n', '<leader>h', builtin.help_tags, {})
keymap('n', '<leader>S', function() require('telescope.builtin').lsp_workspace_symbols {} end, {})
keymap('n', '<leader>s', function() require('telescope.builtin').lsp_document_symbols {} end, {})
keymap('n', '<leader>j', function() require('telescope.builtin').jumplist {} end, {})

-- more leader
keymap('n', '<leader>r', "<cmd>Lspsaga rename ++project<CR>", {})
keymap('n', '<leader>D', "<cmd>Lspsaga show_workspace_diagnostics<CR>", {})
keymap('n', '<leader>d', "<cmd>Lspsaga show_buf_diagnostics<CR>", {})
keymap('n', '<leader>k', "<cmd>Lspsaga hover_doc ++keep<CR>", {})
keymap('n', '<leader>o', "<cmd>Lspsaga outline<CR>", {})
keymap('n', '<leader>u', function() require('undotree').toggle() end, {})

-- g menu
keymap('n', 'gl', "<cmd>Lspsaga lsp_finder<CR>", {})
keymap('n', 'gd', "<cmd>Lspsaga goto_definition<CR>", {})
keymap('n', 'gpd', "<cmd>Lspsaga peek_definition<CR>", {})
keymap('n', 'gt', "<cmd>Lspsaga goto_type_definition<CR>", {})
keymap('n', 'gpt', "<cmd>Lspsaga goto_peek_type_definition<CR>", {})
keymap('n', 'gd', function() require('telescope.builtin').lsp_definitions {} end, {})
keymap('n', 'gt', function() require('telescope.builtin').lsp_type_definitions {} end, {})
keymap('n', 'gr', function() require('telescope.builtin').lsp_references {} end, {})
keymap('n', 'gi', function() require('telescope.builtin').lsp_implementations {} end, {})

--diagnostics
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

-- Diagnostic jump with filters such as only jumping to an error
keymap("n", "[E", function()
  require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "]E", function()
  require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- diagnistcs window
vim.diagnostic.config({
  underline = true,
  signs = true,
  virtual_text = false,
  float = {
    show_header = true,
    source = 'always',
    border = 'rounded',
    focusable = false,
  },
  update_in_insert = false, -- default to false
  severity_sort = false,    -- default to false
})
keymap('n', '<leader>?', function()
  vim.diagnostic.open_float()
end)
