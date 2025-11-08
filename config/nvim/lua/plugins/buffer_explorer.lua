exclude_quickfix = function(item, ctx)
  if item.buf then
    local bt = vim.bo[item.buf].buftype
    if bt == 'quickfix' then
      return false
    end
  end
  return item
end

return {
  {
    'folke/snacks.nvim',
    keys = {
      { '<Leader>be', function() Snacks.picker.buffers() end, desc = 'Buffer Explorer' },
    },
    opts = {
      picker = {
        sources = {
          buffers = {
            format = 'buffer',
            focus = 'list',
            layout = {
              preset = 'select',
              hidden = { 'input', 'preview' },
            },
            win = {
              list = {
                keys = {
                  ['d'] = 'bufdelete',
                },
              },
            },
            transform = exclude_quickfix,
          },
        },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
    },
  },
}
