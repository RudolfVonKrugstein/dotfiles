return {
  "jpalardy/vim-slime",
  init = function()
    vim.g.slime_target = "zellij"
    vim.g.slime_default_config = { session_id = "current", relative_pane = "down" }
  end,
}
