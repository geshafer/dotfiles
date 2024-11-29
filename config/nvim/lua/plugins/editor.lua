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

  -- old vim plugins
  'pbrisbin/vim-mkdir',
  {
    'tpope/vim-commentary', -- replace with numToStr/Comment.nvim
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>/', ':Commentary<cr>', {noremap = true})
      vim.api.nvim_set_keymap('v', '<Leader>/', ':Commentary<cr>', {noremap = true})
    end,
  },
  'tpope/vim-endwise',
  'tpope/vim-eunuch',
  'tpope/vim-fugitive',
  'tpope/vim-projectionist',
  'tpope/vim-rails',
  'tpope/vim-rake',
  'tpope/vim-repeat',
}
