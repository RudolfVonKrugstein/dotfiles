vim.lsp.buf.format()
local g = vim.g
local keymap = vim.keymap.set
local api = vim.api

-- Space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "

-- code action
keymap("n", "<Leader>a", function()
  vim.lsp.buf.code_action()
end, { desc = "code action" })

-- Word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- telescope
local builtin = require('telescope.builtin')
keymap('n', '<leader>f', builtin.find_files, { desc = "Find file" })
keymap('n', '<leader>/', builtin.live_grep, { desc = "Search in pwd" })
keymap('n', '<leader>*', builtin.grep_string, { desc = "Search for word under cursor in workspace" })
keymap('n', '<leader>b', builtin.buffers, { desc = "Find buffer" })
keymap('n', '<leader>h', builtin.help_tags, { desc = "Show help tags" })
keymap('n', '<leader>S', function() require('telescope.builtin').lsp_workspace_symbols {} end,
  { desc = "symbols (workspace)" })
keymap('n', '<leader>s', function() require('telescope.builtin').lsp_document_symbols {} end,
  { desc = "symbols (buffer)" })
keymap('n', '<leader>j', function() require('telescope.builtin').jumplist {} end, { desc = "jumplist" })

-- files
keymap('n', '<leader>e', function() MiniFiles.open() end, {desc="Open file explorer"})

-- more leader
keymap('n', '<leader>r', "<cmd>Lspsaga rename ++project<CR>", { desc = "rename symbole" })
keymap('n', '<leader>D', "<cmd>Lspsaga show_workspace_diagnostics<CR>", { desc = "diagnostics (workspace)" })
keymap('n', '<leader>d', "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "diagnostics (buffer)" })
keymap('n', '<leader>k', "<cmd>Lspsaga hover_doc ++keep<CR>", { desc = "open doc window" })
keymap('n', '<leader>o', "<cmd>Lspsaga outline<CR>", { desc = "toggle outline" })
keymap('n', '<leader>u', function() require('undotree').toggle() end, { desc = "show untootree" })

-- g menu
keymap('n', 'gl', "<cmd>Lspsaga lsp_finder<CR>", { desc = "traverse symbols usage" })
keymap('n', 'gd', "<cmd>Lspsaga goto_definition<CR>", { desc = "goto definition" })
keymap('n', 'gpd', "<cmd>Lspsaga peek_definition<CR>", { desc = "peek definition" })
keymap('n', 'gt', "<cmd>Lspsaga goto_type_definition<CR>", { desc = "goto type definition" })
keymap('n', 'gpt', "<cmd>Lspsaga peek_type_definition<CR>", { desc = "peek type definition" })
keymap('n', 'gr', function() require('telescope.builtin').lsp_references {} end, { desc = "show references" })
keymap('n', 'gi', function() require('telescope.builtin').lsp_implementations {} end, { desc = "show implementations" })

--diagnostics
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "jump to prev lsp diagnostic" })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "jump to next lsp diagnostic" })

-- Diagnostic jump with filters such as only jumping to an error
keymap("n", "[E", function()
  require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "jump to prev lsp error" })
keymap("n", "]E", function()
  require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "jump to next lsp error" })

-- diagnistcs window
vim.diagnostic.config({
  underline = true,
  signs = true,
  virtual_text = true,
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
end, { desc = "show line diagnostics" })

-- neotest
keymap('n', '<leader>t', function()
    require("noetest").summary.toggle()
  end, { desc = "Toggle test summary" })

vim.api.nvim_create_user_command(
  "NeotestRun",
  function()
    require("neotest").run.run()
  end
)

api.nvim_create_user_command(
  "NeotestRunFile",
  function()
    require("neotest").run.run(vim.fn.expand("%"))
  end
)

api.nvim_create_user_command(
  "NeotestDebug",
  function()
    require("neotest").run.run({strategy = "dap"})
  end
)

api.nvim_create_user_command(
  "NeotestStop",
  function()
    require("neotest").run.stop()
  end
)

api.nvim_create_user_command(
  "NeotestAttach",
  function()
    require("neotest").run.attach()
  end
)

api.nvim_create_user_command(
  "NeotestSummaryToggle",
  function()
    require("neotest").suammary.toggle()
  end
)

api.nvim_create_user_command(
  "NeotestSummaryOpen",
  function()
    require("neotest").suammary.open()
  end
)

api.nvim_create_user_command(
  "NeotestSummaryClose",
  function()
    require("neotest").suammary.close()
  end
)

api.nvim_create_user_command(
  "NeotestOutputToggle",
  function()
    require("neotest").output.toggle()
  end
)

api.nvim_create_user_command(
  "NeotestOutputOpen",
  function()
    require("neotest").output.open()
  end
)

api.nvim_create_user_command(
  "NeotestOutputClose",
  function()
    require("neotest").output.close()
  end
)
