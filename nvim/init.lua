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
  { 'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {},
},
{"L3MON4D3/LuaSnip"},
{"williamboman/mason.nvim", lazy=false, build=":MasonUpdate",
config=function()
  require("mason").setup()
end
},
{"williamboman/mason-lspconfig.nvim", lazy=false,
config=function()
  require("mason-lspconfig").setup()
end,
requires = {{"williamboman/mason.nvim"}}
},
{"neovim/nvim-lspconfig", lazy=false,
requires = {{"williamboman/mason.nvim"},{"williamboman/mason-lspconfig"}}
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
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    -- setup nvim plugins
    require('mini.ai').setup({})
    require("mini.basics").setup({options={extra_ui=true}})
    require('mini.align').setup({})
    require('mini.animate').setup({})
    require("config.mini.base16")
    require('mini.bracketed').setup({})
    require('mini.bufremove').setup({})
    require('mini.colors').setup({})
    require('mini.comment').setup({})
    require('mini.cursorword').setup({})
    -- require('mini.doc').setup({})
    require('mini.fuzzy').setup({})
    require('mini.hipatterns').setup({})
    -- require('mini.hues').setup({})
    require('mini.indentscope').setup({})
    require('mini.jump').setup({})
    require('mini.jump2d').setup({})
    require('mini.map').setup({})
    require('mini.misc').setup({})
    require('mini.move').setup({})
    require('mini.pairs').setup({})
    -- require('mini.sessions').setup({})
    require('mini.splitjoin').setup({})
    require('mini.starter').setup({})
    require('mini.statusline').setup({})
    require('mini.surround').setup({})
    require('mini.tabline').setup({})
    -- require('mini.test').setup({})
    -- require('mini.trailspace').setup({})
  end,
},
{"nvim-telescope/telescope.nvim"},
{"nvim-telescope/telescope-ui-select.nvim"}
}
,opts)

