local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim....")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({
  { "scottmckendry/cyberdream.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  { "folke/which-key.nvim" },
  { "folke/trouble.nvim" },
  { "nvim-neotest/nvim-nio" },
  { "nvim-neotest/neotest" },
  { "nvim-neotest/neotest-python" },
  { "wincent/ferret" },
  { "folke/flash.nvim" },
  { "MagicDuck/grug-far.nvim" },
  { "daenikon/marknav.nvim" },
  { "kevinhwang91/nvim-bqf" },
  { "jdrupal-dev/code-refactor.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "jiaoshijie/undotree" },
  { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "L3MON4D3/LuaSnip" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },
  { "altermo/ultimate-autopair.nvim" },
  { "kylechui/nvim-surround" },
  { "echasnovski/mini.nvim" },
  { "mikavilpas/yazi.nvim" },
  { "nvim-tree/nvim-tree.lua" },
  { "elixir-tools/elixir-tools.nvim" },
  { "b0o/schemastore.nvim" },
})

-- general options
local opt = vim.opt

opt.hlsearch = true
opt.number = true
opt.relativenumber = true
opt.hidden = true
opt.mouse = "a"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.signcolumn = "yes"
opt.termguicolors = true
opt.expandtab = true
opt.spelllang = "en,de,cjk"
opt.spell = true
opt.guifont = "JetBrainsMono Nerd Font:h14"
opt.cursorline = true
opt.cursorcolumn = true
opt.timeout = false
opt.ttimeout = false
vim.cmd("colorscheme cyberdream")
vim.cmd("highlight GitSignsAdd guifg=GREEN")
vim.cmd("highlight GitSignsChange guifg=YELLOW")
vim.cmd("highlight GitSignsDelete guifg=RED")
vim.cmd(":set pumblend=0")
vim.cmd(":set winblend=0")
vim.cmd(":set awa")
opt.clipboard = "unnamedplus"

-- git signs
require("gitsigns").setup({})

-- telescope
require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
  defaults = {
    mappings = {
      i = { ["<c-t>"] = require("trouble.sources.telescope").open },
      n = { ["<c-t>"] = require("trouble.sources.telescope").open },
    },
  },
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("file_browser")

-- marknav
require("marknav").setup()

-- undotree
require("undotree").setup({
  float_diff = false,
  layout = "left_bottom",
})

-- yazi
require("yazi").setup({})

-- nvimtree
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  update_focused_file = {
    enable = true,
  },
})

-- autopairs
require("ultimate-autopair").setup({})

-- nvim surround
require("nvim-surround").setup({})

-- mini nvim plugings
-- allows for example replace inner function call via cif
require("mini.ai").setup({})
-- toggle comments
require("mini.comment").setup({})
-- highlight the word under cursor
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})

-- falsh/sneak
require("flash").setup({})
local keymap = vim.api.nvim_set_keymap
keymap("n", "s", '<cmd>lua require("flash").jump()<cr>', { noremap = true, silent = true })
keymap("x", "s", '<cmd>lua require("flash").jump()<cr>', { noremap = true, silent = true })
keymap("o", "s", '<cmd>lua require("flash").jump()<cr>', { noremap = true, silent = true })

keymap("n", "S", '<cmd>lua require("flash").treesitter()<cr>', { noremap = true, silent = true })
keymap("x", "S", '<cmd>lua require("flash").treesitter()<cr>', { noremap = true, silent = true })
keymap("o", "S", '<cmd>lua require("flash").treesitter()<cr>', { noremap = true, silent = true })

-- trouble
require("trouble").setup({})

-- better quickfix
require("bqf").setup({})

-- code refactor
require("code-refactor").setup({})

-- neotest
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
  },
})

-- lsp setup
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  -- keybindings
  -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/README.md#keybindings
  lsp_zero.default_keymaps({ buffer = bufnr })
  vim.lsp.inlay_hint.enable()
end)

-- set some fancy icons
lsp_zero.set_sign_icons({
  error = "✘",
  warn = "▲",
  hint = "⚑",
  info = "»",
})

-- special lsp setup
-- gleam
require("lspconfig").gleam.setup({})

-- jsonls
require("lspconfig").jsonls.setup({
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})
-- yamls
require("lspconfig").yamlls.setup({
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- schemaStore plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})
-- bsedpyright
require("lspconfig").basedpyright.setup({
  cmd = { "poetry", "run", "basedpyright-langserver", "--stdio" },
  single_file_support = true,
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- openFilesOnly, workspace
        typeCheckingMode = "basic", -- off, basic, strict
        useLibraryCodeForTypes = true,
      },
    },
  },
})
-- ruff lsp
require("lspconfig").ruff_lsp.setup({
  cmd = { "poetry", "run", "ruff-lsp" },
})

-- setup efm
require("lspconfig").efm.setup({
  init_options = {
    documentFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true,
  },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      markdown = {
        {
          lintCommand = "markdownlint -s",
          lintStdin = true,
          lintFormats = {
            "%f:%l %m",
            "%f:%l:%c %m",
            "%f: %l: %m",
          },
        },
        {
          formatCommand = "mdformat --wrap 120 -",
          formatStdin = true,
        },
      },
      lua = {
        {
          formatCommand = "stylua -",
          formatStdin = true,
        },
      },
      python = {
        {
          formatCommand = "ruff format  -",
          formatStdin = true,
        },
        {
          formatCommand = "isort --quiet -",
          formatStdin = true,
        },
      },
      gleam = {
        {
          formatCommand = "gleam format --stdin",
          formatStdin = true,
        },
      },
    },
  },
})

-- setup treesitter
require("nvim-treesitter.configs").setup({
  compilers = { "clang", "gcc" },
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {},

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = true,
  -- List of parsers to ignore installing
  ignore_install = {},
  -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
  modules = {},
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})
require("nvim-treesitter").compilers = { "clang", "gcc" }

-- setup mason and lspconfig
require("mason").setup({})

require("mason-lspconfig").setup({
  ensure_installed = {
    "astro",
    "efm",
    "elixirls",
    "taplo",
    "basedpyright",
    "tailwindcss",
    "tflint",
    "terraformls",
    "tsserver",
    "clangd",
    "cssls",
    "html",
    "lua_ls",
    "bashls",
    "spectral",
    "jsonls",
    "yamlls",
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)
    end,
  },
})

-- setup nvim-cmp
local cmp = require("cmp")
local ind = cmp.lsp.CompletionItemKind
local luasnip = require("luasnip")
local cmp_action = lsp_zero.cmp_action()

-- elixir
local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup({
  nextls = { enabled = true },
  credo = { enabled = true },
  elixirls = {
    enable = true,
    settings = elixirls.settings({
      dialyzerEnabled = false,
      enableTestLenses = false,
    }),
    on_attach = function(client, bufnr)
      vim.keymap.set("n", "<space>cp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "<space>cp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "<space>ce", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
    end,
  },
})

-- exit insert mode with jj
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape" })

-- setup autopair with nvim cmp
-- cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
-- setup ultimate autopair with cmp
local function ls_name_from_event(event)
  return event.entry.source.source.client.config.name
end

-- Add parenthesis on completion confirmation
cmp.event:on("confirm_done", function(event)
  local ok, ls_name = pcall(ls_name_from_event, event)
  if ok and vim.tbl_contains({ "rust_analyzer" }, ls_name) then
    return
  end

  local completion_kind = event.entry:get_completion_item().kind
  if vim.tbl_contains({ ind.Function, ind.Method }, completion_kind) then
    local left = vim.api.nvim_replace_termcodes("<Left>", true, true, true)
    vim.api.nvim_feedkeys("()" .. left, "n", false)
  end
end)

-- load more snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- supertab functions
local function luasnip_supertab(select_opts)
  return cmp.mapping(function(fallback)
    local col = vim.fn.col(".") - 1

    if cmp.visible() then
      cmp.select_next_item(select_opts)
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
      fallback()
    else
      cmp.complete()
    end
  end, { "i", "s" })
end

local function luasnip_shift_supertab(select_opts)
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item(select_opts)
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" })
end

cmp.setup({
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "luasnip", keyword_length = 2 },
    { name = "buffer", keyword_length = 3 },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- complete common
    ["<Tab>"] = luasnip_supertab(),
    ["<S-Tab>"] = luasnip_shift_supertab(),

    -- confirm completion item
    ["<Enter>"] = cmp.mapping.confirm({ select = false }),
    ["<S-Enter>"] = cmp.mapping.confirm({ select = true }),

    -- trigger completion menu
    ["<C-Space>"] = cmp.mapping.complete(),

    -- abort
    ["<C-e>"] = cmp.mapping.abort(),

    -- scroll up and down the documentation window
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),

    -- navigate between snippet placeholders
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
  }),
  formatting = lsp_zero.cmp_format(),
})

-- lualine
local function lsp_server()
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return "[]"
  end
  local result = "[ "
  local first_client = true
  for _, client in ipairs(clients) do
    if not first_client then
      result = result .. ", "
    end
    result = result .. client.name
    first_client = false
  end
  return result .. " ]"
end

require("lualine").setup({
  component_separators = { left = "", right = "" },
  section_separators = { left = "", right = "" },
  theme = "codedark",
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { lsp_server, "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})

local api = vim.api

-- Highlight on yank
api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
  ]],
  false
)

-- close certain windows with q
local group = vim.api.nvim_create_augroup("NeotestConfig", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "neotest-output", "neotest-summary", "quickfix" },
  group = group,
  callback = function(opts)
    vim.keymap.set("n", "q", function()
      pcall(vim.api.nvim_win_close, 0, true)
    end, {
      buffer = opts.buf,
    })
  end,
})

-- nvim grug-far for searching and replacing
require("grug-far").setup()

-- keymaps
require("which-key").setup()
local wk = require("which-key")
wk.setup()
local ts_builtin = require("telescope.builtin")
local ts_file_browser_extension = require("telescope").extensions.file_browser

local g = vim.g
local keymap = vim.keymap.set
local api = vim.api
vim.o.timeout = true
vim.o.timeoutlen = 300
-- Space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "
wk.register({
  c = {
    name = "code",
    f = {
      "<cmd>LspZeroFormat efm<CR>",
      "format code",
    },
    a = {
      function()
        vim.lsp.buf.code_action()
      end,
      "code action",
    },
    b = {
      "<cmd>CodeActions all<CR>",
      "non lsp code action",
    },
    s = { ts_builtin.lsp_workspace_symbols, "symbols (workspace)" },
    S = { ts_builtin.lsp_document_symbols, "symbols (document)" },
    r = { vim.lsp.buf.rename, "rename symbol" },
  },
  f = {
    name = "file",
    f = { ts_builtin.find_files, "Find files" },
    b = { ts_file_browser_extension.file_browser, "browse files" },
    e = {
      function()
        require("yazi").yazi()
      end,
      "Open file explorer",
    },
    E = {
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      "Open file explorer in working directory",
    },
    t = { "<CMD>NvimTreeFocus<CR>", "Open/Focus NvimTree" },
    s = { "<CMD>LspZeroFormat efm<CR><CMD>w<CR>", "save" },
  },
  u = {
    function()
      require("undotree").toggle()
    end,
    "Toggle Undotree",
  },
  d = {
    name = "diagnostics",
    d = {
      function()
        vim.diagnostic.open_float()
      end,
      "show line diagnostic",
    },
    l = {
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      "document diagnostics",
    },
    w = {
      "<cmd>Trouble diagnostics toggle<cr>",
      "workspace diagnostics",
    },
    q = {
      "<cmd>Trouble qflist toggle<cr>",
      "open quickfix list in trouble",
    },
  },
  s = {
    name = "search",
    g = { ts_builtin.live_grep, "Live Grep" },
    w = { ts_builtin.grep_string, "Search for word under cursor in workspace" },
    s = { ":Ack ", "search in files to quickfix list" },
    n = { ":Quack ", "narrow items in quickfix list" },
    r = { ":Acks ", "replace items in quickfix list" },
    S = { ":GrugFar", "Search and replace using grug-far" },
  },
  b = {
    name = "buffer",
    b = { ts_builtin.buffers, "Find buffer" },
    d = { "<cmd>bdelete<CR>", "Delete buffer" },
  },
  h = { ts_builtin.help_tags, "Show help tags" },
  j = {
    ts_builtin.jumplist,
    "Jump List",
  },
  p = { ts_builtin.register, "Paste from register" },
  l = {
    name = "language and spelling",
    l = { ts_builtin.spell_suggest, "fix spelling" },
    e = { "<cmd>setlocal spell spelllang=en_us<CR>", "switch to english" },
    d = { "<cmd>setlocal spell spelllang=de_de<CR>", "switch to german" },
  },
  t = {
    name = "test",
    s = { require("neotest").summary.toggle, "Toggle neotest summary" },
    r = { require("neotest").run.run, "Run closest test" },
    o = {
      function()
        require("neotest").output.open({ enter = true })
      end,
      "Open test output window",
    },
    d = {
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      "Debug closest test",
    },
    f = {
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      "Run all test in file",
    },
    x = {
      require("neotest").run.stop,
      "Stop closes test",
    },
  },
}, { prefix = "<leader>" })

wk.register({
  d = { ts_builtin.lsp_definitions, "jump to definition" },
  D = { vim.lsp.buf.declaration, "jump to declaration" },
  k = { ts_builtin.lsp_type_definitions, "jump to type definition" },
  r = { "<cmd>Trouble lsp_references focus<CR>", "jump to references" },
  i = { "<cmd>Trouble lsp_implementations focus<CR>", "jump to implementation" },
  l = { ts_builtin.lsp_incoming_calls, "jump to incoming calls" },
  o = { ts_builtin.lsp_outgoing_calls, "jump to outgoing calls" },
  s = { vim.lsp.buf.signature_help, "show signature help" },

  m = { ts_builtin.marks, "jump to mark" },
}, { prefix = "g" })

wk.register({
  d = { vim.diagnostic.goto_next, "Next diagnostic" },
}, { prefix = "]" })
wk.register({
  d = { vim.diagnostic.goto_prev, "Previous diagnostic" },
}, { prefix = "[" })

wk.register({
  K = {
    vim.lsp.buf.hover,
    "Help/Hover",
  },
})

-- signature help in insert mode
keymap("i", "<C-s>", vim.lsp.buf.signature_help, { noremap = true })
