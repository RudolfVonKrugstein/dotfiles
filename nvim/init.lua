-- auto install lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- install plugins
require("lazy").setup({
  -- basics
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
  -- color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  -- syntax highlightin
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- show register contents when pressing "
  {
    "folke/which-key.nvim",
    layz = false,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
    end,
  },
  -- file opening and other stuff to do with fuzzy selection
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    init = function()
      require("telescope").load_extension("file_browser")
    end,
  },
  -- project management
  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    config = function()
      require("project_nvim").setup({ silent_chdir = false })
      require("telescope").load_extension("projects")
    end,
  },
  -- insert paired character for things like " and brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    check_ts = true, -- use treesitter to check if pairs should be inserted
    opts = {
      check_ts = true, -- enalbe treesitter
      ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
      map_c_w = true, -- delete a pair
      disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
    },
  },
  -- surround objects with brackets and similar
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  { "L3MON4D3/LuaSnip" },
  -- basic lsp config
  -- mason installs lsp servers and other tools
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  -- help with configuring different lsp servers
  -- the config is happening in context if nvim-cmp
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ocamllsp",
          "astro",
          "efm",
          "elixirls",
          "taplo",
          "ruff_lsp",
          "pyright",
          "tailwindcss",
          "tflint",
          "terraformls",
          "tsserver",
          "clangd",
          "cssls",
          "html",
          "lua_ls",
        },
      })
    end,
    requires = { { "williamboman/mason.nvim" } },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    requires = { { "williamboman/mason.nvim" }, { "williamboman/mason-lspconfig" } },
  },
  -- autocompletion
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "hrsh7th/cmp-cmdline",
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.nvim-cmp")
    end,
  },
  -- show lsp hints as inlay text
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("lsp-inlayhints").setup({
        inlay_hints = {
          highlight = "Comment",
        },
      })
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
    end,
  },
  -- show lsp hints below the line (can be toggled)
  {
    "https://github.com/RudolfVonKrugstein/lsp_lines.git",
    config = function()
      require("lsp_lines").setup()
    end,
  },
  -- {
  --   "folke/trouble.nvim",
  --   config = function()
  --     require("trouble").setup()
  --   end,
  -- },
  {
    "echasnovski/mini.nvim",
    version = "*",
    init = function()
      -- show the current idention
      require("config.mini.indentscope").init()
    end,
    config = function(_, opts)
      -- setup nvim plugins
      -- allows for example replace inner function call via cif
      require("mini.ai").setup({})
      -- move between different signs using brackets
      require("mini.bracketed").setup({})
      -- toggle comments
      require("mini.comment").setup({})
      -- highlight the word under cursor
      require("mini.cursorword").setup({})
      require("config.mini.indentscope").config(_, opts)
      -- better jumping via f
      require("mini.jump").setup({})
      -- move selection. TODO: configure
      require("mini.move").setup({})
    end,
  },
  -- file manager
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        keymaps = {
          ["q"] = "actions.close",
        },
      })
    end,
  },
  -- switch between header and main source
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        mappings = {
          {
            pattern = "(.*).ml$",
            target = "%1.mli",
          },
          {
            pattern = "(.*).mli$",
            target = "%1.ml",
          },
        },
      })
    end,
  },
  -- {
  --   "glepnir/lspsaga.nvim",
  --   event = "LspAttach",
  --   config = function()
  --     require("lspsaga").setup({
  --       lightbulb = {
  --         enable = false,
  --       },
  --     })
  --   end,
  --   dependencies = {
  --     { "nvim-treesitter/nvim-treesitter" },
  --   },
  -- },
  -- lsp features of all kind
  {
    "ray-x/navigator.lua",
    dependencies = { "ray-x/navigator.lua", "ray-x/navigator.lua" },
    config = function()
      require("navigator").setup({
        mason = true,
        transparency = 0,
        treesitter_analysis = false, -- to slow
        lsp = {
          disable_lsp = { "pylsp" },
          format_on_save = false,
        },
      })
    end,
  },
  -- rust
  {
    "simrat39/rust-tools.nvim",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("config.rust-tools")
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)
      crates.show()
    end,
  },
  -- allow undoing stuff in a window
  {
    "jiaoshijie/undotree",
    lazy = false,
    config = function()
      require("undotree").setup({
        float_diff = false,
        layout = "left_bottom",
      })
    end,
  },
  -- show git change status
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "?" },
        },
      })
    end,
  },
  -- {
  --   "tpope/vim-fugitive",
  -- },
  -- show lsp messages on the lower left
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
    tag = "legacy",
    requires = { "neovim/nvim-lspconfig" },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("config.lualine")
    end,
  },
  -- status line
  {
    "nvim-neotest/neotest-python",
  },
  -- {
  --   "rouge8/neotest-rust",
  -- },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "rouge8/neotest-rust",
  --     "nvim-neotest/neotest-python",
  --   },
  --   config = function()
  --     require("neotest").setup({
  --       signs = true,
  --       virtual_text = true,
  --       adapters = {
  --         require("neotest-python")({
  --           runner = "pytest",
  --         }),
  --         require("neotest-rust")({}),
  --       },
  --       quickfix = {
  --         open = false,
  --       },
  --     })
  --   end,
  -- },
  -- auto format the code
  {
    "mhartington/formatter.nvim",
    config = function()
      require("config.formatter")
    end,
  },
  -- auto show linting stuff, more than lsp
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("config.linter")
    end,
  },
  -- dap
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = { handlers = {} },
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-dap" },
    config = function()
      require("config.dap-ui")
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mfussenegger/nvim-dap", "williamboman/mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        automatic_installation = true,
      })
    end,
  },
  -- repl
  { "tpope/vim-repeat" },
  { "pappasam/nvim-repl" },
  -- python specific stuff
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "nvim-dap" },
    config = function()
      require("dap-python").setup()
    end,
  },
  -- tabbar
  { "romgrk/barbar.nvim", opts = {} },
  -- hydra
  {
    "anuvyklack/hydra.nvim",
    dependencies = { "sindrets/winshift.nvim", "mrjones2014/smart-splits.nvim", "romgrk/barbar.nvim" },
    config = function()
      require("config.hydra.windows")
    end,
  },
  -- obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/projects/private/notes",
        },
      },
    },
  },
}, {})

--merlin (opam/ocaml
local opamshare = vim.api.nvim_eval("substitute(system('opam var share'),'\n$','','''')")
vim.opt.runtimepath:append(opamshare .. "$opamshare/merlin/vim")
