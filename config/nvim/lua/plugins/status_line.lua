return {
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      progress = {
        display = {
          render_limit = 5,
          format_message = function(msg)
            if msg.percentage then
              return string.format('%d%%', msg.percentage)
            end
            return msg.done and '✔' or nil
          end,
          format_annote = function()
            return nil
          end,
          format_group_name = function(group)
            return tostring(group)
          end,
        },
      },
      notification = {
        view = {
          stack_upwards = false,
        },
        window = {
          border = 'rounded',
          winblend = 0,
          normal_hl = 'Normal',
          align = 'top',
          x_padding = 2,
          y_padding = 1,
        },
        configs = {
          default = {
            info_annote = '',
          },
        },
      },
    },
  },
  {
    'hoob3rt/lualine.nvim',
    lazy = false, -- make sure we load this during startup
    priority = 900, -- make sure to load this before everything except the colorscheme
    opts = {
      options = {
        theme = 'kanagawa',
      },
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
