return {
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
  'pbrisbin/vim-mkdir',
  'tpope/vim-endwise',
  'tpope/vim-eunuch',
  'tpope/vim-fugitive',
  'tpope/vim-projectionist',
  'tpope/vim-rails',
  'tpope/vim-rake',
  'tpope/vim-repeat',
}
