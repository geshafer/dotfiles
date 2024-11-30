return {
  {
    "yetone/avante.nvim",
    version = false, -- set this if you want to always pull the latest change
    build = "make", -- to build from source use `make BUILD_FROM_SOURCE=true`
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { '<leader>aa', '<Plug>(AvanteAsk)', mode = { 'n', 'v' } },
    },
    opts = {
      provider = "openai",
      openai = { -- override openai provider to work with Shopify proxy
        endpoint = os.getenv("OPENAI_API_CHAT_COMPLETIONS"),
        model = "anthropic:claude-3-5-sonnet",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
    },
  },
}
