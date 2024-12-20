default_on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }

  -- The default mappings we want to setup for every lsp
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

return {
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
    },
    cmd = { 'Mason' },
    ft = { 'ruby', 'go' },
    opts = {
      ensure_installed = {
        -- Ruby
        'rubocop',
        'ruby_lsp',
        'sorbet',

        -- Go
        'gopls',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({ on_attach = default_on_attach })
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
