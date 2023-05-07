local set = vim.opt

set.spelllang = 'en,de,cjk'
set.guifont = 'JetBrainsMono NF:h14'
set.relativenumber = true
set.cursorline = true
set.cursorcolumn = true

vim.api.nvim_create_autocmd({"BufRead"},{
  pattern = {"*.rs"},
  callback = function()
    vim.lsp.start({
      name = "leptos-language-server",
      cmd = {"leptos-language-server"},
      root_dir = vim.fs.dirname(vim.fs.find({'Cargo.toml'}, { upward = true })[1]),
    });
  end
})
