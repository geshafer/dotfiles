local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('loctvl842/monokai-pro.nvim')

Plug('hoob3rt/lualine.nvim')

Plug('jlanzarotta/bufexplorer')

Plug('numkil/ag.nvim')

Plug('axelf4/vim-strip-trailing-whitespace')

Plug('neovim/nvim-lspconfig')

Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

-- This doesn't always work. If telescope is erroring do the following
-- cd ~/.config/nvim/plugged/telescope-fzf-native.nvim && make
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make'})

-- Plug('nvim-lua/plenary.nvim')
Plug('lewis6991/gitsigns.nvim')

Plug('ethanholz/nvim-lastplace')

Plug('kyazdani42/nvim-web-devicons')
Plug('kyazdani42/nvim-tree.lua')

Plug('pbrisbin/vim-mkdir')
Plug('tpope/vim-commentary')
Plug('tpope/vim-endwise')
Plug('tpope/vim-eunuch')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-projectionist')
Plug('tpope/vim-rails')
Plug('tpope/vim-rake')
Plug('tpope/vim-repeat')

-- AI Code Helper like Cursor or Copilot chat
Plug('yetone/avante.nvim', {['do'] = 'make'})
-- Plug('kyazdani42/nvim-web-devicons')
Plug('stevearc/dressing.nvim')
-- Plug('nvim-lua/plenary.nvim')
Plug('MunifTanjim/nui.nvim')

vim.call('plug#end')
