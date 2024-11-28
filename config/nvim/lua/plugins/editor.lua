return {
  'jlanzarotta/bufexplorer',
  {
    'doums/rg.nvim',
    cmd = { 'Rg' },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>rg', ':Rg <C-r><C-w><cr>', {noremap = true})
      vim.api.nvim_set_keymap('v', '<Leader>rg', ':Rg <C-r><C-w><cr>', {noremap = true})
    end,
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
  },
  'ethanholz/nvim-lastplace',

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
