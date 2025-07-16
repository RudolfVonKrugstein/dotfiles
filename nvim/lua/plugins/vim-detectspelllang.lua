return {
  "Konfekt/vim-DetectSpellLang",
  init = function()
    vim.g.detectspelllang_langs = {
      aspell = { "en_US", "de_DE" },
      hunspell = { "en_US", "de_DE" },
    }
  end,
}
