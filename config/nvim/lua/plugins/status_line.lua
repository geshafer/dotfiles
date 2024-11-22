return {
  {
    'hoob3rt/lualine.nvim',
    opts = {
      options = {theme = 'monokai-pro'},
      sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {
          {'filename', path = 1}
        },
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {'filename', path = 1}
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
