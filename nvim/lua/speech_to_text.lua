-- speech_to_text.lua
-- Place in ~/.config/nvim/lua/speech_to_text.lua
-- Then in your init.lua: require('speech_to_text').setup()
--
-- Press <leader>sr to start recording, press it again to stop;
-- the audio is then transcribed with whisper-cli and the text is
-- inserted at the cursor.
 
local M = {}
 
local config = {
  model = vim.fn.expand("~/models/ggml-base.bin"),
  language = "de",
  rate = 44100,
  channels = 2,
  keymap = "<leader>sr",
}
 
local state = {
  record_job = nil,
  rawfile = nil,
  wavfile = nil,
  txtbase = nil,
}
 
local function notify(msg, level)
  vim.notify("[STT] " .. msg, level or vim.log.levels.INFO)
end
 
local function cleanup()
  for _, f in ipairs({ state.rawfile, state.wavfile, state.txtbase and (state.txtbase .. ".txt") }) do
    if f and vim.fn.filereadable(f) == 1 then
      vim.fn.delete(f)
    end
  end
  state.record_job, state.rawfile, state.wavfile, state.txtbase = nil, nil, nil, nil
end
 
local function insert_transcript()
  local txt_file = state.txtbase .. ".txt"
  local ok, lines = pcall(vim.fn.readfile, txt_file)
  if not ok or not lines or #lines == 0 then
    notify("No transcription output", vim.log.levels.WARN)
    cleanup()
    return
  end
 
  -- Strip leading/trailing blank lines and surrounding whitespace
  while #lines > 0 and lines[1]:match("^%s*$") do table.remove(lines, 1) end
  while #lines > 0 and lines[#lines]:match("^%s*$") do table.remove(lines, #lines) end
  for i, l in ipairs(lines) do
    lines[i] = l:gsub("^%s+", ""):gsub("%s+$", "")
  end
 
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
  notify("Done — " .. #lines .. " line(s) inserted")
  cleanup()
end
 
local function transcribe()
  notify("Transcribing…")
  vim.fn.jobstart({
    "whisper-cli",
    "-m", config.model,
    "--output-txt",
    "-of", state.txtbase,
    "--no-prints",
    "-l", config.language,
    state.wavfile,
  }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          notify("whisper-cli failed (exit " .. code .. ")", vim.log.levels.ERROR)
          cleanup()
          return
        end
        insert_transcript()
      end)
    end,
  })
end
 
local function convert_and_transcribe()
  -- Convert the raw PCM capture to wav, then transcribe.
  vim.fn.jobstart({
    "sox",
    "-t", "raw",
    "-r", tostring(config.rate),
    "-e", "signed",
    "-b", "16",
    "-c", tostring(config.channels),
    state.rawfile,
    state.wavfile,
  }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          notify("sox conversion failed (exit " .. code .. ")", vim.log.levels.ERROR)
          cleanup()
          return
        end
        transcribe()
      end)
    end,
  })
end
 
function M.start_recording()
  if state.record_job then
    notify("Already recording", vim.log.levels.WARN)
    return
  end
 
  state.rawfile = vim.fn.tempname() .. ".raw"
  state.wavfile = vim.fn.tempname() .. ".wav"
  state.txtbase = vim.fn.tempname()
 
  -- Record raw PCM directly instead of piping into sox while recording.
  -- Killing a parec|sox pipeline mid-stream can leave a truncated wav
  -- (sox never writes the final header). Recording raw and converting
  -- afterwards is lossless and robust.
  -- `exec` replaces the shell, so jobstop()'s SIGTERM hits parec directly.
  local cmd = string.format(
    "exec parec --format=s16le --rate=%d --channels=%d > %s",
    config.rate, config.channels, vim.fn.shellescape(state.rawfile)
  )
 
  state.record_job = vim.fn.jobstart({ "sh", "-c", cmd }, {
    on_exit = function(_, code)
      state.record_job = nil
      -- 143 = SIGTERM, the normal way we stop the recording
      if code ~= 0 and code ~= 143 then
        notify("Recording process error (exit " .. code .. ")", vim.log.levels.ERROR)
        cleanup()
        return
      end
      -- Small delay so the file is fully flushed to disk
      vim.defer_fn(convert_and_transcribe, 200)
    end,
  })
 
  if state.record_job <= 0 then
    notify("Failed to start parec. Is PulseAudio/PipeWire running?", vim.log.levels.ERROR)
    cleanup()
    return
  end
 
  notify("Recording… press the mapping again to stop")
end
 
function M.stop_recording()
  if not state.record_job then
    notify("Not recording", vim.log.levels.WARN)
    return
  end
  vim.fn.jobstop(state.record_job)
  -- Transcription continues in the recording job's on_exit callback
end
 
function M.toggle_recording()
  if state.record_job then
    M.stop_recording()
  else
    M.start_recording()
  end
end
 
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
 
  vim.api.nvim_create_user_command("SpeechToText", M.toggle_recording, {
    desc = "Toggle speech-to-text recording",
  })
 
  if config.keymap then
    vim.keymap.set("n", config.keymap, M.toggle_recording, {
      desc = "STT: toggle recording / transcribe",
      noremap = true,
      silent = true,
    })
  end
end
 
return M
