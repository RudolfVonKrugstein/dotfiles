vim.lsp.buf.format()
local g = vim.g
local keymap = vim.keymap.set

-- Space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "

-- code action
keymap("n", "<Leader>a", vim.lsp.buf.code_action, { noremap = true, expr = true, silent = true })

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
