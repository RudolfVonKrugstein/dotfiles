vim.pack.add({ "https://github.com/Avi-D-coder/whisper.nvim" })
require('whisper').setup({
  -- Binary detection
  binary_path = nil,  -- Auto-detect if nil

  -- Model settings
  model = 'small.de',  -- Options: 'tiny.en', 'base.en', 'small.en', 'medium.en', etc.
  auto_download_model = true,

  -- Keybindings
  keybind = '<C-g>',
  manual_trigger_key = '<Space>',
  modes = {'n', 'i', 'v'},

  -- Whisper parameters
  threads = 8,         -- Number of CPU threads
  step_ms = 20000,     -- Process audio every 20 seconds
  length_ms = 25000,   -- 25 second audio buffer
  vad_thold = 0.60,    -- Voice activity detection threshold (0.0-1.0)
  language = 'de',

  -- Streaming parameters
  enable_streaming = true,
  poll_interval_ms = 20000,     -- Auto-insert every 20 seconds
  filter_markers = true,        -- Remove [BLANK_AUDIO], [MUSIC], etc.

  -- UI settings
  show_whisper_output = false,
  notifications = true,

  -- Debug settings
  debug = false,
  debug_file = '/tmp/whisper-debug.log',
})
