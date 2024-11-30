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
  {
    'cappyzawa/trim.nvim',
    event = 'VeryLazy',
    config = true,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = true,
  },
  {
    'ethanholz/nvim-lastplace',
    lazy = false, -- make sure we load this during startup
    priority = 800, -- make sure to load this before everything except the status line
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
  {
    'tpope/vim-eunuch',
    cmd = { 'Remove', 'Delete', 'Move', 'Rename', 'Mkdir'  }
  }
}
