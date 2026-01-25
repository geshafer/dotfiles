local lsp_config = require('config.lsp')

return {
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'j-hui/fidget.nvim',
    },
    cmd = { 'Mason' },
    ft = { 'go' },
    opts = {
      ensure_installed = {
        -- Go
        'gopls',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({ on_attach = lsp_config.on_attach })
        end
      },
    },
    config = function(_, opts)
      require('mason').setup()
      require('mason-lspconfig').setup(opts)
    end,
  },
  {
    'folke/lazydev.nvim', -- lsp extensions for lua
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
