return {
  {
    'matbme/JABS.nvim',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    keys = {
      { '<leader>be', ':JABSOpen<cr>', desc = 'Open buffer explorer' },
    },
    opts = {
      relative = 'editor',
      position = {'center', 'center'},
      keymap = {
        preview = 'i',
      },
      sort_mru = true,
    },
  },
}
