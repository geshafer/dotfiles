return {
  {
    'hoob3rt/lualine.nvim',
    lazy = false, -- make sure we load this during startup
    priority = 900, -- make sure to load this before everything except the colorscheme
    opts = {
      options = {theme = 'kanagawa'},
      sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {
          {'filename', path = 1}
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'location'},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {'filename', path = 0}
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
