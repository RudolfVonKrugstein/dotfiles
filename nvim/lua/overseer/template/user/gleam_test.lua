return {
  name = "gleam test",
  builder = function()
    return {
      cmd = { "gleam", "test" },
      -- attach a component to the task that will pipe the output to the quickfix.
      -- components customize the behavior of a task.
      -- see :help overseer-components for a list of all components.
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  -- provide a condition so the task will only be available when you are in a c++ file
  condition = {
    filetype = { "gleam" },
  },
}
