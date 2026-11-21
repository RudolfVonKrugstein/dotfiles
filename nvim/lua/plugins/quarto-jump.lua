-- quarto-jump: jump from a `quarto preview` page in the browser to the source
-- in Neovim (Alt+J = current slide/section, Alt+click = clicked element), and
-- let the browser follow the cursor.
--
-- The Quarto project needs the `quarto-jump` extension, see the plugin's README.
--
--   :QuartoJumpStatus   port, connected browsers, sync on/off
--   :QuartoJumpSync     toggle browser following the cursor
--   :QuartoJumpShow     show the cursor position in the browser now

vim.pack.add({ "https://github.com/huesken-org/quarto-neovim-jump-to-slide" })
require("quarto-jump").setup({})
