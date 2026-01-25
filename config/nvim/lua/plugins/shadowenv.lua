return {
  "Shopify/shadowenv.vim",
  priority = 100,
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
      callback = function()
        vim.cmd("silent! ShadowenvHook")
      end,
    })
  end,
}
