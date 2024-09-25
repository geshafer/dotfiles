local set = vim.opt

vim.g.mapleader = ","

set.backspace = "2"       -- Backspace deletes like most programs in insert mode
set.history = 50
set.ruler = true          -- show the cursor position all the time
set.showcmd = true        -- display incomplete commands
set.incsearch = true      -- do incremental searching
set.laststatus = 2        -- Always display the status line
set.autowrite = true      -- Automatically :write before running commands
set.modelines = 0         -- Disable modelines as a security precaution
set.guicursor = "i:block" -- Use block cursor in input mode

require('bundles')

require("monokai-pro").setup({
  filter = "spectrum"
})
vim.cmd([[colorscheme monokai-pro]])

-- Initialize Status Line
require('lualine').setup({
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
})

-- Initialize TreeSitter
require('nvim-treesitter.configs').setup({
  ensure_installed = { "css", "dockerfile", "elixir", "go", "html", "javascript", "json", "latex", "lua", "make", "ruby", "scss", "tsx", "typescript", "vim", "yaml" },
  highlight = {enable = true},
  indent = {enable = true},
})

-- Initialize LSP
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'sorbet', 'gopls' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

-- Initialize Fuzzy Finder
local telescope_actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = telescope_actions.close
      },
    },
  }
}
require('telescope').load_extension('fzf')
vim.api.nvim_set_keymap('n', '<Leader>t', '<cmd>Telescope find_files<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>g', '<cmd>Telescope live_grep<cr>', {noremap = true})

-- Initialize Git Gutter
require('gitsigns').setup()

-- Show hide file browser
require('nvim-tree').setup({
  git = { enable = true, ignore = false, timeout = 500 }
})
vim.api.nvim_set_keymap('n', '<Leader>n', ':NvimTreeToggle<cr>', {noremap = true, silent = true})
vim.g.nvim_tree_show_icons = { folders = 1, folder_arrows = 1 }

-- Comment with leader + /
vim.api.nvim_set_keymap('n', '<Leader>/', ':Commentary<cr>', {noremap = true})
vim.api.nvim_set_keymap('v', '<Leader>/', ':Commentary<cr>', {noremap = true})

-- Remember last cursor position
require('nvim-lastplace').setup({})

-- Configure Avante Code Assistant
require('avante_lib').load()
require('avante').setup({
  provider = "openai",
  openai = {
    endpoint = os.getenv("OPENAI_API_CHAT_COMPLETIONS"),
    model = "anthropic:claude-3-5-sonnet",
    timeout = 30000, -- Timeout in milliseconds
    temperature = 0,
    max_tokens = 4096,
    ["local"] = false,
  },
})

-- matchit?
-- Strip whitespace on save

-- When the type of shell script is /bin/sh, assume a POSIX-compatible
-- shell for syntax highlighting purposes.
vim.g.is_posix = 1

-- Softtabs, 2 spaces
set.tabstop = 2
set.shiftwidth = 2
set.shiftround = true
set.expandtab = true

-- Display extra whitespace
set.list = true
set.listchars = {tab = '»·', trail = '·', nbsp = '·'}

-- Make it obvious where 120 characters is
set.textwidth = 120
set.colorcolumn = "+1"

-- Numbers
set.number = true
set.numberwidth = 5

-- Tab completion
set.wildmode = "list:longest,list:full"

-- Treat <li> and <p> tags like the block tags they are
vim.g.html_indent_tags = "li|p"

-- Open new split panes to right and bottom, which feels more natural
set.splitbelow = true
set.splitright = true

-- Quicker window movement
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})

-- Sane searching
vim.api.nvim_set_keymap('n', '/', '/\\v', {noremap = true})
vim.api.nvim_set_keymap('v', '/', '/\\v', {noremap = true})
set.gdefault = true
set.showmatch = true
vim.api.nvim_set_keymap('n', '<tab>', '%', {noremap = true})
vim.api.nvim_set_keymap('v', '<tab>', '%', {noremap = true})

-- Clear search results
vim.api.nvim_set_keymap('n', '<Leader><space>', ':noh<cr>', {noremap = true})

-- Send all vim registers to the mac clipboard
set.clipboard = "unnamedplus"
if(vim.env.SPIN == "1")
then
  vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
      ["+"] = 'pbcopy',
      ["*"] = 'pbcopy',
    },
    paste = {
      ["+"] = 'pbpaste',
      ["*"] = 'pbpaste',
    },
    cache_enabled = 1
  }
end

-- Remap space to center on current line
vim.api.nvim_set_keymap('n', '<space>', 'zz', {})

-- Customize Airline
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_b = ''

-- Highlight matches as you type.
set.incsearch = true
-- Highlight matches.
set.hlsearch = true
-- Case-insensitive searching.
set.ignorecase = true
-- But case-sensitive if expression contains a capital letter.
set.smartcase = true

-- Turn off line wrapping.
set.wrap = false
-- Show 3 lines of context around the cursor.
set.scrolloff = 3

-- Set the terminal's title
set.title = true

-- No beeping.
set.visualbell = true

-- Set persistent undo history
set.undodir = vim.fn.stdpath('config') .. "/undo/"
set.undofile = true
