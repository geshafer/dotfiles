return {
  -- the colorscheme should be available when starting Neovim
  {
    'loctvl842/monokai-pro.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      filter = 'spectrum',
    },
    config = function(_, opts)
      -- load the colorscheme here
      require('monokai-pro').setup(opts)
      vim.cmd([[colorscheme monokai-pro]])
    end,
  },
}
