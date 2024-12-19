return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c",
        "css",
        "dockerfile",
        "elixir",
        "go",
        "html",
        "javascript",
        "json",
        "latex",
        "lua",
        "make",
        "markdown",
        "ruby",
        "scss",
        "terraform",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml"
      },
      highlight = {enable = true},
      indent = {enable = true},
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
