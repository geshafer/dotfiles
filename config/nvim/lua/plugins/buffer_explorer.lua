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
      height = 16,
      width = 100,
      relative = 'editor',
      position = {'center', 'center'},
      sort_mru = true, -- most recently used
      split_filename = true, -- show path separately
      split_filename_path_width = 50,

      keymap = {
        close = 'd',
        preview = 'i',
      },

      symbols = {
        current = " ◦",
        split = " ◦",
        alternate = " •",
        hidden = " •",

        locked = "",
        ro = "",
        edited = "",
        terminal = "",
        default_file = "",
        terminal_symbol = "",
      },
    },
  },
}
