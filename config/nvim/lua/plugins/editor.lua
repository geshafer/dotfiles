return {
  {
    'FabijanZulj/blame.nvim',
    cmd = { 'BlameToggle', 'Git' },
    config = function(_, opts)
      require('blame').setup(opts)

      -- Old habits die hard. Custom vim-fugitive command.
      vim.api.nvim_create_user_command('Git', 'BlameToggle window', { desc = 'Git Blame', nargs = '*' })
    end,
  },
  'jlanzarotta/bufexplorer',
  {
    'doums/rg.nvim',
    cmd = { 'Rg' },
    keys = {
      { "<leader>rg", ":Rg <C-r><C-w><cr>", desc = "Ripgrep" },
    },
    opts = {
      excluded = {
        '.git',
      },
    },
  },
  'axelf4/vim-strip-trailing-whitespace',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = true,
  },
  {
    'ethanholz/nvim-lastplace',
    config = true,
  },
  {
    'numToStr/Comment.nvim',
    keys = {
      { '<Leader>/', '<Plug>(comment_toggle_linewise_current)', mode = 'n', noremap = true, desc = "Toggle Comment" },
      { '<Leader>/', '<Plug>(comment_toggle_linewise_visual)', mode = 'v', noremap = true, desc = "Toggle Comment" },
    },
    opts = {
      mappings = false,
    }
  },

  -- old vim plugins
  'tpope/vim-eunuch',
}
