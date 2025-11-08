return {
  {
    'folke/snacks.nvim',
    keys = {
      { '<Leader>t', function() Snacks.picker.smart() end, desc = 'Fuzzy File Finder' },
    },
    opts = {
      picker = {
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
