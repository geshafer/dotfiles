return {
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    keys = {
      { '<Leader>n', ':NvimTreeFindFile<cr>' },
    },
    opts = {
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      }
    },
  },
}
