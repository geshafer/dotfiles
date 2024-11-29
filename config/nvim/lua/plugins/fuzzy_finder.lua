return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- This doesn't always work. If telescope is erroring do the following
        -- cd ~/.config/nvim/plugged/telescope-fzf-native.nvim && make
        build = 'make',
      },
    },
    keys = {
      { '<Leader>t', '<cmd>Telescope find_files<cr>', desc = 'Telescope Fuzzy Finder' }
    },
    opts = function()
      local telescope_actions = require('telescope.actions')
      return {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = telescope_actions.close
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension('fzf')
    end,
  },
}
