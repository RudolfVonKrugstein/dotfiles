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
require("lazy").setup(
  {
    { 'kyazdani42/nvim-web-devicons' },
    { 'nvim-lua/plenary.nvim' },
    {
      'folke/which-key.nvim',
      event = "VeryLazy",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup()
      end,
    },
    {
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
      opts = {},
    },
    { "L3MON4D3/LuaSnip" },
    {
      "williamboman/mason.nvim",
      lazy = false,
      build = ":MasonUpdate",
      config = function()
        require("mason").setup()
      end
    },
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = false,
      config = function()
        require("mason-lspconfig").setup()
      end,
      requires = { { "williamboman/mason.nvim" } }
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      requires = { { "williamboman/mason.nvim" }, { "williamboman/mason-lspconfig" } }
    },
    {
      "hrsh7th/cmp-nvim-lsp"
    },
    {
      "hrsh7th/cmp-buffer"
    },
    {
      "hrsh7th/cmp-path"
    },
    {
      "hrsh7th/cmp-cmdline"
    },
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("config.nvim-cmp")
      end
    },
    {
      "lvimuser/lsp-inlayhints.nvim",
      config = function()
        require("lsp-inlayhints").setup({
          inlay_hints = {
            highlight = "Comment"
          }
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
      end
    },
    {
      "folke/trouble.nvim",
      config = function()
        require("trouble").setup()
      end
    },
    {
      'echasnovski/mini.nvim',
      version = '*',
      init = function()
        require("config.mini.indentscope").init()
      end,
      config = function(_, opts)
        -- setup nvim plugins
        require('mini.ai').setup({})
        require("mini.basics").setup({ options = { extra_ui = true } })
        require('mini.align').setup({})
        -- require('mini.animate').setup({})
        -- require("config.mini.base16")
        require('mini.bracketed').setup({})
        require('mini.bufremove').setup({})
        -- require('mini.colors').setup({})
        require('mini.comment').setup({})
        require('mini.cursorword').setup({})
        -- require('mini.doc').setup({})
        require('mini.fuzzy').setup({})
        -- require('mini.hipatterns').setup({})
        -- require('mini.hues').setup({})
        require('config.mini.indentscope').config(_, opts)
        --  require('mini.jump').setup({})
        -- require('mini.jump2d').setup({})
        require('mini.map').setup({})
        require('mini.misc').setup({})
        require('mini.move').setup({})
        require('mini.pairs').setup({})
        -- require('mini.sessions').setup({})
        require('mini.splitjoin').setup({})
        require('mini.starter').setup({})
        -- require('mini.statusline').setup({})
        require('mini.surround').setup({})
        require('mini.tabline').setup({})
        -- require('mini.test').setup({})
        -- require('mini.trailspace').setup({})
      end,
    },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
      "glepnir/lspsaga.nvim",
      event = "LspAttach",
      config = function()
        require("lspsaga").setup({
          lightbulb = {
            enable = true
          }
        })
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter" }
      }
    },
    -- rust
    {
      "simrat39/rust-tools.nvim",
      dependencies = "neovim/nvim-lspconfig",
      config = function()
        require("config.rust-tools")
      end
    },
    {
      "saecki/crates.nvim",
      ft = { "rust", "toml" },
      config = function(_, opts)
        local crates = require("crates")
        crates.setup(opts)
        crates.show()
      end
    },
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
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require('gitsigns').setup {
          signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '-' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '?' },
          },
        }
      end
    },
    {
      "tpope/vim-fugitive"
    },
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup()
      end
    }
  }
  , opts)
