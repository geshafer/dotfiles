return {
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    opts = {
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      }
    },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>n', ':NvimTreeFindFile<cr>', {noremap = true, silent = true})
      vim.g.nvim_tree_show_icons = {folders = 1, folder_arrows = 1}
    end,
  },
}
