M = {}

M.init = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {
      'alpha',
      'coc-explorer',
      'dashboard',
      'fzf', -- fzf-lua
      'help',
      'lazy',
      'lazyterm',
      "undotree",
      'lspsagafinder',
      'lspsagaoutline',
      'mason',
      'neo-tree',
      'nnn',
      'notify',
      'NvimTree',
      'qf',
      'starter', -- mini.starter
      'toggleterm',
      'Trouble',
    },
    callback = function()
      vim.b.miniindentscope_disable = true
      vim.schedule(function()
        if MiniIndentscope then MiniIndentscope.undraw() end
      end)
    end,
  })
end

M.config = function(_, opts)
  local indent_scope = require('mini.indentscope')
  -- opts.draw.animation = indent_scope.gen_animation.none()

  indent_scope.setup(opts)
end

return M
