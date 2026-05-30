vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim", "https://github.com/kyzadev/vocal.nvim" })

require("vocal").setup({
  api_key = nil,
  -- Directory to save recordings
  recording_dir = os.getenv("HOME") .. "/.recordings",
  -- Delete recordings after transcription
  delete_recordings = true,
  -- Keybinding to trigger :Vocal (set to nil to disable)
  keymap = "<leader>vr",

  -- Local model configuration (set this to use local model instead of API)
  local_model = {
    model = "medium",       -- Model size: tiny, base, small, medium, large
    path = "~/whisper",   -- Path to download and store models
  },
})
