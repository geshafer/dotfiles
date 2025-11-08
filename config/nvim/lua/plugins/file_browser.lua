return {
  {
    'folke/snacks.nvim',
    keys = {
      { '<Leader>n', function() Snacks.explorer() end, desc = 'File Browser' },
    },
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = {
              preset = 'sidebar',
              hidden = { 'input', 'preview' },
            },
            git_status = false,
          },
        },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
    },
  },
}
